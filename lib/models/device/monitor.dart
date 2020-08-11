import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/protocol.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;

// 可执行程序配置 : 目前由于支持了服务器崩溃自动重启,那么这里只需要配置游戏服务器和客户端了
class MonitorExecutable {
  String exec;
  List<String> args; // 程序的启动参数
  List<String> envs; // 环境变量定义
  MonitorExecutable({this.exec, this.args, this.envs});

  bool IsGameExe(){
    return exec.contains("robot.exe") || exec.contains("ghoul.exe") || exec.contains("ResidentEvil.exe")
        || exec.contains("robot-Win64-Shipping.exe") || exec.contains("ghoul-Win64-Shipping.exe") || exec.contains("ResidentEvil-Win64-Shipping.exe");
  }
}

// 进程状态
class MonitorProcessState {
  String exec;
  bool running;
  int lastUpdateTimestamp;
  MonitorProcessState({this.exec, this.running, this.lastUpdateTimestamp});
}

// 每台电脑设备都具有的对象,用来控制进程的执行,监控进程的状态等
class Monitor extends Device {
  // 超时时间 : 超过这个时间,就认为进程关闭啦.
  final int MAX_DELAY_TIME = 5000;
  // 电量,整数百分比
  int batteryPercentage = 0;
  // 校准状态
  bool calibration = false;
  // 可**远程控制执行**的程序配置列表
  Map<String, MonitorExecutable> executables =
      new Map<String, MonitorExecutable>();
  // 监控设备的进程信息
  Map<String, MonitorProcessState> processes =
      new Map<String, MonitorProcessState>();
  // raw数据,方便处理
  List<MonitorExecutable> rawExecutables = new List<MonitorExecutable>();
  List<MonitorProcessState> rawProcesses = new List<MonitorProcessState>();
  /**
   * 硬件数据
   */
  // 配置的名称
  String name;
  // IP地址
  String ip;

  // 临时数据
  String prevCalibrationResult = "none";
  bool prevCalibrationSuccess = false;

  Monitor(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.MONITOR;
  }

  // 设备状态
  @override
  DeviceStateValue status() {
    var now = DateTime.now().millisecondsSinceEpoch;
    if ((now - lastStatTimestamp) > 4 * 1000) {
      // 局域网应该没有多少个设备,超过2s则认为关机了.
      return DeviceStateValue.OFF;
    }
    return DeviceStateValue.IDLE;
  }

  @override
  register() {
    super.register();
    Application.connection
        .on(Protocol.TopicsOperateCalibrationBegin, this.onCalibrationBegin);
    Application.connection
        .on(Protocol.TopicsOperateCalibrationEnd, this.onCalibrationEnd);
    Application.connection.on(
        Protocol.TopicsOperateWorkerRunResult + "/" + id.toString(),
        this.onExecutionResult);
    Application.connection.on(
        Protocol.TopicsOperateWorkerWatchStatus + "/" + id.toString(),
        this.onProcessResult);
    Application.connection
        .on(Protocol.TopicsOperateWorkerConfig, this.onMonitorConfig);
    Application.connection
        .on(Protocol.TopicsOperateWorkerConfigs, this.onMonitorConfigs);
  }

  @override
  unRegister() {
    super.unRegister();
    Application.connection
        .off(Protocol.TopicsOperateCalibrationBegin, this.onCalibrationBegin);
    Application.connection
        .off(Protocol.TopicsOperateCalibrationEnd, this.onCalibrationEnd);
    Application.connection.on(
        Protocol.TopicsOperateWorkerRunResult + "/" + id.toString(),
        this.onExecutionResult);
    Application.connection.on(
        Protocol.TopicsOperateWorkerWatchStatus + "/" + id.toString(),
        this.onProcessResult);
    Application.connection
        .on(Protocol.TopicsOperateWorkerConfig, this.onMonitorConfig);
    Application.connection
        .on(Protocol.TopicsOperateWorkerConfigs, this.onMonitorConfigs);
  }

  void onCalibrationBegin(String topic, Map<String, dynamic> list) {
    CalibrationBegin w = CalibrationBegin.fromJson(list);
    if (w.id == id) {
      lastStatTimestamp = DateTime.now().millisecondsSinceEpoch;
      calibration = true;
      globalEvent.emit(DeviceDispatcher.MONITOR_DETAIL_CHANGED);
    }
  }

  void onCalibrationEnd(String topic, Map<String, dynamic> list) {
    CalibrationEnd w = CalibrationEnd.fromJson(list);
    if (w.id == id) {
      lastStatTimestamp = DateTime.now().millisecondsSinceEpoch;
      calibration = false;
      prevCalibrationSuccess = w.result == 0;
      if (w.result == 0) {
        prevCalibrationResult = "success";
      } else {
        switch (w.result) {
          case 1000:
            prevCalibrationResult = "校准点数目不正确,可能是网络问题";
            break;
          case 1001:
            prevCalibrationResult = "校准点数目应该为2个";
            break;
          case 999:
            prevCalibrationResult = "网络异常";
            break;
          default:
            prevCalibrationResult = "error-code : " + w.result.toString();
            break;
        }
      }
      globalEvent.emit(DeviceDispatcher.MONITOR_DETAIL_CHANGED);
    }
  }

  void onExecutionResult(String topic, Map<String, dynamic> list) {
    RunnerResult w = RunnerResult.fromJson(list);
    if (w.id == id) {
      if (w.code == 0) {
        // 运行成功,进程设置为正在运行!
        var t = DateTime.now().millisecondsSinceEpoch;
        updateProcess(
            w.exec,
            w.action == ExecutionType.START ||
                w.action == ExecutionType.RESTART,
            t,
            true);
        globalEvent.emit(DeviceDispatcher.MONITOR_DETAIL_CHANGED);
      }
      // TODO:界面如何显示一下?
//    w.result
//    w.code
    }
  }

  void onProcessResult(String topic, Map<String, dynamic> list) {
    WatchStatusList w = WatchStatusList.fromJson(list);
    if (w.id == id) {
      w.list.forEach((WatchStatus w) {
        var t = DateTime.now().millisecondsSinceEpoch;
        updateProcess(w.process.exec, w.status, t, true);
      });
      globalEvent.emit(DeviceDispatcher.MONITOR_DETAIL_CHANGED);
    }
  }

  void onMonitorConfig(String topic, Map<String, dynamic> list) {
    WorkerConfig w = WorkerConfig.fromJson(list);
    updateProperties(w);
  }

  void onMonitorConfigs(String topic, Map<String, dynamic> list) {
    WorkerList w = WorkerList.fromJson(list);
    w.list.any((WorkerConfig c) {
      if (c.id == id) {
        updateProperties(c);
        return true;
      }
      return false;
    });
  }

  @override
  void onHardwareState(String topic, Map<String, dynamic> list) {
    super.onHardwareState(topic, list);

    // 只需要处理'switch state'部分
    HardwareStateUpdate w = HardwareStateUpdate.fromJson(list);
    if (w.id == id && w.type == this.type()) {
      for (int i = 0; i < w.stats.length; ++i) {
        if (w.stats[i].state == DeviceStateType.BATTERY) {
          batteryPercentage = w.stats[i].value;
          lastStatTimestamp = DateTime.now().millisecondsSinceEpoch;
        }
      }
      globalEvent.emit(DeviceDispatcher.MONITOR_DETAIL_CHANGED);
    }
  }

  // 运行程序
  //  - 运行游戏程序
  //  - 运行校准程序
  @override
  void turnOn(dynamic args) {
    runWithName(args as String, ExecutionType.START);
  }

  @override
  void turnOff(dynamic args) {
    runWithName(args as String, ExecutionType.STOP);
  }

  // 外部API:取得某个进程是否正在运行
  bool isRunning(String name) {
    // 注意:如果name中包含文件夹路径等,则需要预先处理一下
    List<String> n = path.split(name);
    String p = n[n.length - 1];
    var shortName = p == name;
    if (shortName) {
      if (processes.containsKey(p)) {
        var t = DateTime.now().millisecondsSinceEpoch;
        return processes[p].running &&
            (t - processes[p].lastUpdateTimestamp) < MAX_DELAY_TIME;
      }
    } else {
      bool running = false;
      rawProcesses.any((rp) {
        if (rp.exec == name) {
          var t = DateTime.now().millisecondsSinceEpoch;
          running = rp.running && (t - rp.lastUpdateTimestamp) < MAX_DELAY_TIME;
        }
      });
      return running;
    }
    return false;
  }

  // 外部API:通过索引确定1个进程是否正在运行
  bool isRunningWithIndex(int index) {
    if (index >= 0 && index < rawProcesses.length) {
      var p = rawProcesses[index];
      var t = DateTime.now().millisecondsSinceEpoch;
      return p.running && (t - p.lastUpdateTimestamp) < MAX_DELAY_TIME;
    }
    return false;
  }

  bool isGameRunning() {
    return isRunning("robot.exe") || isRunning("ghoul.exe") || isRunning("ResidentEvil.exe")
        || isRunning("robot-Win64-Shipping.exe") || isRunning("ghoul-Win64-Shipping.exe") || isRunning("ResidentEvil-Win64-Shipping.exe");
  }

  bool isCalibrationRunning() {
    return calibration && isRunning("fixer.exe");
  }

  // 外部API:取得所有可执行程序列表
  List<MonitorExecutable> getExecutables() {
    return rawExecutables;
  }

  // 外部API:取得所有监控的进程列表
  List<MonitorProcessState> getProcesses() {
    return rawProcesses;
  }

  // 外部API:取得电量生于
  int getBatteryPercentage() {
    return batteryPercentage;
  }

  // 外部API:取得绑定头显得tracker电量
  int getTrackerBatteryPercentage() {
    // 注意:服务器返回得是0.xxx小数
    double d = Application.dataCenter.getTrackerBatteryWithMonitorId(id);
    return (d * 100).round();
  }

  // 外部API:取得绑定头显是否穿戴
  bool getHMDMounted() {
    return Application.dataCenter.isHmdMountedWithMonitorId(id);
  }

  // 外部API:取得绑定头显是否丢失
  bool getHMDLosted() {
    return Application.dataCenter.isHmdLostedWithMonitorId(id);
  }

  // 外部API:获取基础属性
  String getName() {
    return name;
  }

  String getIpAddress() {
    return ip;
  }

  // 外部API:更新属性
  void updateProperties(WorkerConfig w) {
    if (w.id == id) {
      name = w.name;
      ip = w.ip;
      w.runner.forEach((WorkerRunner r) {
        updateExecutable(r.exec, r.args, r.envs, true);
      });
      w.watcher.forEach((WorkerWatcher w) {
        var t = DateTime.now().millisecondsSinceEpoch;
        updateProcess(w.exec, false, t, true);
      });
      globalEvent.emit(DeviceDispatcher.MONITOR_DETAIL_CHANGED);
    }
  }

  void updateExecutable(
      String exec, List<String> args, List<String> envs, bool addIfNotExist) {
    var n = path.split(exec);
    var p = n[n.length - 1];
    var shortName = p == exec; // 简短名称只能更新,不能新增
    if (shortName) {
      if (executables.containsKey(p)) {
        executables[p].envs = envs;
        executables[p].args = args;
      }
    } else {
      // 直接从rawExecutables处理
      var exist = rawExecutables.any((r) {
        if (r.exec == exec) {
          r.args = args;
          r.envs = envs;
          return true;
        }
        return false;
      });
      if (!exist && addIfNotExist) {
        // 新增
        var e = MonitorExecutable(exec: exec, args: args, envs: envs);
        rawExecutables.add(e);
        executables[p] = e;
      }
    }
  }

  void updateProcess(
      String exec, bool running, int timestamp, bool addIfNotExist) {
    var n = path.split(exec);
    var p = n[n.length - 1];
    var shortName = p == exec; // 简短名称只能更新,不能新增
    if (shortName) {
      if (processes.containsKey(p)) {
        processes[p].running = running;
        processes[p].lastUpdateTimestamp = timestamp;
      }
    } else {
      // 直接从rawProcesses处理
      var exist = rawProcesses.any((r) {
        if (r.exec == exec) {
          r.running = running;
          r.lastUpdateTimestamp = timestamp;
          return true;
        }
        return false;
      });
      if (!exist && addIfNotExist) {
        // 新增
        var e = MonitorProcessState(
            exec: exec, running: running, lastUpdateTimestamp: timestamp);
        rawProcesses.add(e);
        processes[p] = e;
      }
    }
  }

  void _runInternal(MonitorExecutable v, int a){
    if (v == null){
      return;
    }

    Application.connection.sendMessage(
        Protocol.TopicsOperateWorkerRun + "/" + id.toString(),
        json.encode(RunCommand(
            cmd: WorkerRunner(
              exec: v.exec,
              envs: v.envs,
              args: v.args,
            ),
            action: a)));
  }

  // 指定索引运行
  void runWithIndex(int index, int a) {
    if (rawExecutables.length > index && index >= 0) {
      var v = rawExecutables[index];
      _runInternal(v, a);
    }
  }

  // 重新校准
  void startGenerateTracking() {
    // 注意:影动力不支持该功能
    if (!Application.dataCenter.settingData.data.useYdl) {
      Application.connection.sendMessage(Protocol.TopicsOperateGenerateTracking,
          json.encode(GenerateTracking(id: id)));
    }
  }

  // 指定名称运行
  void runWithName(String name, ExecutionType action) {
    List<String> n = path.split(name);
    String p = n[n.length - 1];
    var shortName = p == name;
    if (shortName) {
      if (executables.containsKey(p)) {
        var v = executables[p];
        _runInternal(v, action.value);
      }
    } else {
      rawExecutables.any((r) {
        if (r.exec == name) {
          var v = r;
          _runInternal(v, action.value);
          return true;
        }
        return false;
      });
    }
  }

  double getBatterPercentage() {
    return 100;
  }
}
