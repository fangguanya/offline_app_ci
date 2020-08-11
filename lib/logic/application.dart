import 'dart:async';
import 'dart:convert';

import 'package:operator_controller/logic/connection.dart';
import 'package:flutter/material.dart';
import 'package:operator_controller/logic/link.dart';
import 'package:operator_controller/logic/datagram.dart';
import 'package:operator_controller/main.dart';
import 'package:operator_controller/models/config_data.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/device/audio.dart';
import 'package:operator_controller/models/device/center_server.dart';
import 'package:operator_controller/models/device/elevator.dart';
import 'package:operator_controller/models/device/game_server.dart';
import 'package:operator_controller/models/device/joystick.dart';
import 'package:operator_controller/models/device/monitor.dart';
import 'package:operator_controller/models/device/rotator.dart';
import 'package:operator_controller/models/device/switcher.dart';
import 'package:operator_controller/models/device/track_server.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/onegame/gameviewport.dart';
import 'package:operator_controller/logic/sharing.dart';

import 'constants.dart';
import 'package:flutter/foundation.dart';

class Application {
  static Connection connection;
  static BuildContext context;
  static MyAppState main;
  static Link transmit;
  static Link tracker;
  static Datagram hardwareYDL; // 控制影动力的接口

  static DataCenter dataCenter;

  static GlobalKey<NavigatorState> navState = new GlobalKey();
  static bool newsetting = false;

  static void onIpChanged() {
    connection.broker = dataCenter.settingData.data.ip;
//    transmit.connect("10.3.5.250", 9100);
//    tracker.connect("10.3.5.250", 9099);
    transmit.reconnect();
    tracker.reconnect();
    connection.reconnect();
  }

  static void onYdlIpChanged() {
    hardwareYDL.connect(dataCenter.settingData.data.ydlip, 33002, 33001);
  }
  static void onRecordAddressChanged(){}

  static void onUseYdlChanged() {}
  static void onCloseSteamVRChanged() {}

  static bool isNew() {
    if (dataCenter == null ||
        dataCenter.settingData == null ||
        dataCenter.settingData.data == null ||
        dataCenter.settingData.data.newVersion == null) {
      return false;
    }
    return dataCenter.settingData.data.newVersion;
  }
}

// 数据中心
class DataCenter {
  final IvrData deviceListUI = IvrData();

  final Map<String, OneGameData> gameDatas = Map<String, OneGameData>();
  final Map<String, MapEntry<int, int>> monitorPid =
      Map<String, MapEntry<int, int>>(); // 映射：设备id与进程配置中的id
  final Map<String, int> hmdIdx = Map<String, int>();
  final Map<String, int> weaponIdx = Map<String, int>();
  final Map<String, int> seatStatus = Map<String, int>();

  final SettingData settingData = SettingData();

  final Map<WorkerRelation, Device> hardwares =
      new Map<WorkerRelation, Device>();

  final List<WorkerRelation> hardwareRelations = new List<WorkerRelation>();
  final List<WorkerRelation> pcRelations = new List<WorkerRelation>();

  // 当前配置的校准模式
  int calibrationStatus = 1; // (0:HTC,1:RIFTS,2:HYBRID)
  // 定位服务器ip端口
  String trackingIp = "";
  int trackingPort = 0;
  // 状态转发服务器ip端口
  String transmitIp = "";
  int transmitPort = 0;
  // 当前的进程状态(是否前台?等)
  bool isForeground = true;

  bool getForeground() {
    return isForeground;
  }

  void setForeground(bool b) {
    isForeground = b;
  }

  // 玩家定位器是否定位
  final Map<int, IvrTrackerStatus> trackers = Map<int, IvrTrackerStatus>();
  // 所有的定位位置信息
  final Map<int, IvrDeviceTransform> devices = Map<int, IvrDeviceTransform>();
  // 玩家oculus状态
  final Map<int, IvrHMDStatus> hmds = Map<int, IvrHMDStatus>();
  // 所有映射信息
  final Map<String, int> reflects = Map<String, int>();

  // 社交分享处理
  final Sharing sharing = Sharing();

  DataCenter();

  void register() {
    Application.connection
        .on(Protocol.TopicsOperateWorkerConfig, this.onMonitorConfig);
    Application.connection
        .on(Protocol.TopicsOperateWorkerConfigs, this.onMonitorConfigs);
    Application.connection
        .on(Protocol.TopicsOperateHardwareState, this.onHardwareState);
    Application.connection
        .on(Protocol.TopicsOperateWorkerRelationConfigs, this.onRelationConfig);
    Application.connection.on(
        Protocol.TopicsOperateConfigGameRemoteGetResult, this.onRemoteConfig);

    Application.transmit
        .on(IvrGrabHtsMessageType.GET_DEVICE_STATE.index, this.onDeviceState);
    Application.tracker
        .on(IvrGrabHtsMessageType.GET_REFLECT_STATE.index, this.onReflectState);
    Application.tracker.on(
        IvrGrabHtsMessageType.GET_REFLECT_STATE1.index, this.onReflectState);
    Application.tracker
        .on(IvrGrabHtsMessageType.GET_DEVICE_STATE.index, this.onDeviceState);

    Application.hardwareYDL.on("HardwareOnline", this.onYdlHardwareState);

    // 社交视频分享的消息注册
    sharing.register();
  }

  T getHardware<T>(DeviceType type, int id) {
    T result;
    hardwares.forEach((k, v) {
      if (v.type() == type && v.id == id) {
        result = v as T;
      }
    });
    return result;
  }

  T getHardwareByRelation<T>(WorkerRelation i) {
    if (hardwares.containsKey(i)) {
      return hardwares[i] as T;
    }
    return null;
  }

  // 方便影动力得情况下,没有对应得后台控制程序时处理!
  T getHardwareOrCreate<T>(WorkerRelation i) {
    if (hardwares.containsKey(i)) {
      return hardwares[i] as T;
    }

    DeviceType type = i.type;
    int id = i.id;
    int ydlid = i.ydlid;
    Device d = null;
    // 其他设备类型
    if (type == DeviceType.SWITCH) {
      d = new Switcher(id, ydlid);
    } else if (type == DeviceType.ELEVATOR) {
      d = new Elevator(id, ydlid);
    } else if (type == DeviceType.ROTATOR) {
      d = new Rotator(id, ydlid);
    } else if (type == DeviceType.JOYSTICK) {
      d = new Joystick(id, ydlid);
    } else if (type == DeviceType.AUDIO) {
      d = new Audio(id, ydlid);
    } else if (type == DeviceType.GSERVER) {
      d = new GameServer(id, ydlid);
    } else if (type == DeviceType.HSERVER) {
      d = new CenterServer(id, ydlid);
    } else if (type == DeviceType.TSERVER) {
      d = new TrackServer(id, ydlid);
    }
    hardwares[i] = d;
    return d as T;
  }

  List<T> getHardwares<T>(DeviceType type) {
    List<T> result = new List<T>();
    hardwares.forEach((idx, dev) {
      if (dev.type() == type) {
        result.add(dev as T);
      }
    });
    return result;
  }

  Device getYdlHardware(int ydlid) {
    if (ydlid < 0) {
      return null;
    }
    Device result = null;
    hardwares.forEach((idx, dev) {
      if (dev.idydl() == ydlid) {
        result = dev;
      }
    });
    return result;
  }

  Monitor getMonitor(int id) {
    return getHardware(DeviceType.MONITOR, id) as Monitor;
  }

  List<Monitor> getMonitors() {
    return getHardwares(DeviceType.MONITOR);
  }

  bool isSeatRead(String cid) {
    if (seatStatus.containsKey(cid)) {
      return seatStatus[cid] == 1;
    }
    return false;
  }

  int getCalibrationStatus() {
    return calibrationStatus;
  }

  void setCalibrationStatus(int s) {
    calibrationStatus = s;
    Application.connection.sendMessage(
        Protocol.TopicsOperateConfigGameRemoteSet,
        json.encode(ConfigRemoteConfigSet(status: s)));
    globalEvent.emit(DeviceDispatcher.STATS_CHANGED);
  }

  /**
   * 硬件消息处理
   */
  void onRemoteConfig(String topic, Map<String, dynamic> list) {
    ConfigRemoteConfig w = ConfigRemoteConfig.fromJson(list);
    calibrationStatus = w.status;
    trackingIp = w.trackingip;
    trackingPort = w.trackingport;
    transmitIp = w.transmitip;
    transmitPort = w.transmitport;

    Application.transmit.connect(transmitIp, transmitPort);
    Application.tracker.connect(trackingIp, trackingPort);
    globalEvent.emit(DeviceDispatcher.STATS_CHANGED);
    globalEvent.refreshUI(UIID.UI_Hardware);
    globalEvent.refreshUI(UIID.UI_AllDevices);
    globalEvent.refreshUI(UIID.UI_BattleMap);
  }

  void onRelationConfig(String topic, Map<String, dynamic> list) {
    // 直接替换
    RelationList w = RelationList.fromJson(list);
    hardwareRelations.clear();
    hardwareRelations.addAll(w.hdlist);
    pcRelations.clear();
    pcRelations.addAll(w.pclist);

    // 填充硬件
    hardwareRelations.forEach((w) {
      Application.dataCenter.getHardwareOrCreate(w);
    });

    globalEvent.emit(DeviceDispatcher.RELATIONS_CHANGED);
    globalEvent.refreshUI(UIID.UI_Hardware);
    globalEvent.refreshUI(UIID.UI_AllDevices);
    globalEvent.refreshUI(UIID.UI_BattleMap);
  }

  void onMonitorConfig(String topic, Map<String, dynamic> list) {
    WorkerConfig w = WorkerConfig.fromJson(list);
    WorkerRelation id = WorkerRelation(type: DeviceType.MONITOR, id: w.id);
    if (!hardwares.containsKey(id)) {
      // monitor
      Monitor m = new Monitor(w.id, 0);
      m.register();
      m.updateProperties(w);
      hardwares[id] = m;
      globalEvent.emit(DeviceDispatcher.MONITOR_CHANGED);
      globalEvent.refreshUI(UIID.UI_Hardware);
      globalEvent.refreshUI(UIID.UI_AllDevices);
      globalEvent.refreshUI(UIID.UI_BattleMap);
    }
  }

  void onMonitorConfigs(String topic, Map<String, dynamic> list) {
    WorkerList w = WorkerList.fromJson(list);
    w.list.forEach((WorkerConfig c) {
      WorkerRelation id = WorkerRelation(type: DeviceType.MONITOR, id: c.id);
      if (!hardwares.containsKey(id)) {
        // monitor
        Monitor m = new Monitor(c.id, 0);
        m.register();
        m.updateProperties(c);
        hardwares[id] = m;
        globalEvent.emit(DeviceDispatcher.MONITOR_CHANGED);
        globalEvent.refreshUI(UIID.UI_Hardware);
        globalEvent.refreshUI(UIID.UI_AllDevices);
        globalEvent.refreshUI(UIID.UI_BattleMap);
      }
    });
  }

  void onHardwareState(String topic, Map<String, dynamic> list) {
    HardwareStateUpdate w = HardwareStateUpdate.fromJson(list);
    if (w.type == null) {
      print("无法识别的硬件设备类型:" + w.id.toString());
    } else {
      Device d = getHardware<Device>(w.type, w.id);
      if (d != null) {
        d.onHardwareState(topic, list);
      }
    }
  }

  void onYdlHardwareState(String msg) {
    if (!Application.dataCenter.getForeground()) {
      return;
    }
    var stats = msg.toLowerCase().split(",");
    stats.forEach((stat) {
      try {
        int idx = stat.indexOf("id");
        if (idx < 0) {
          return;
        }
        // 进行拆分:去掉id
        stat = stat.substring(idx + 2);
        var nums = stat.split("-");
        if (nums.length > 2) {
          int id = int.parse(nums[0]);
          int onoff = int.parse(nums[1]);
          int run = int.parse(nums[2]);
          var dev = getYdlHardware(id);
          if (dev != null) {
            dev.onYdlHardwareState(onoff == 1, run == 1);
          }
        }
      } on Exception catch (e) {
        print("onYdlHardwareState: exception raised $e");
      }
    });
  }

  void setReflect(String serial, int id) {
    Application.tracker.sendMessage(
        IvrGrabHtsMessageType.SET_REFLECT_STATE.index,
        IvrSetReflectState(
          serial: serial,
          id: id,
        ));
  }

  void onReflectState(int t, Map<String, dynamic> list) {
    IvrGetReflectStateResult w = IvrGetReflectStateResult.fromJson(list);
    reflects.clear();
    w.reflects.forEach((k, v) {
      reflects[k] = v;
    });
    globalEvent.refreshUI(UIID.UI_Settings);
    globalEvent.emit(DeviceDispatcher.REFLECT_STATE_CHANGED);
  }

  void onDeviceState(int t, Map<String, dynamic> list) {
    IvrGetDeviceStateResult w = IvrGetDeviceStateResult.fromJson(list);

    w.trackers.forEach((k, v) {
      trackers[k] = v;
//      print('----id:${v.id}, state:${v.tracked}, battery:${v.battery}');
    });
    w.devices.forEach((k, v) {
      devices[k] = v;
//      print('id:${v.id} type:${v.type} hybrid:${v.hybridPosition.x},${v.hybridPosition.y},${v.htcPosition.z} and htc:${v.htcPosition.x},${v.htcPosition.y},${v.htcPosition.z},}');
    });
    w.hmds.forEach((k, v) {
      hmds[k] = v;
    });
    globalEvent.emit(DeviceDispatcher.DEVICE_STATE_CHANGED);
    globalEvent.refreshUI(UIID.UI_BattleMap);
  }

  // API
  bool modifyingAllDevices = false;
  void loadDevices(bool all) {
    reflects.clear();
    modifyingAllDevices = all;
    if (modifyingAllDevices) {
      Application.tracker.sendMessage(
          IvrGrabHtsMessageType.GET_REFLECT_STATE1.index,
          IvrGetReflectState(timestamp: 0));
    } else {
      Application.tracker.sendMessage(
          IvrGrabHtsMessageType.GET_REFLECT_STATE.index,
          IvrGetReflectState(timestamp: 0));
    }
  }

  void modifyDevice(String serial, int id) {
    if (modifyingAllDevices) {
      Application.tracker.sendMessage(
          IvrGrabHtsMessageType.SET_REFLECT_STATE1.index,
          IvrSetReflectState(serial: serial, id: id));
    } else {
      Application.tracker.sendMessage(
          IvrGrabHtsMessageType.SET_REFLECT_STATE.index,
          IvrSetReflectState(serial: serial, id: id));
    }
  }

  Future<void> load() async {
    await settingData.load();
    await MyGameProfile.load();

    if (settingData.data.ip != null) {
      print('加载配置完毕: ${settingData.data.ip}');
      Application.onIpChanged();
    }
    if (settingData.data.ydlip != null) {
      Application.onYdlIpChanged();
    }

    await Future.value().timeout(const Duration(seconds: 1));

    globalEvent.refreshUI(UIID.UI_Settings);
    print('加载数据完毕');
  }

  bool shouldHasClient(String id) {
    bool b = false;
    gameDatas.forEach((k, v) {
      if (v.desiredDeviceList.contains(id)) {
        b = true;
      }
    });
    return b;
  }

  String getServerIdByClientId(String cid) {
    String b = '';
    gameDatas.forEach((k, v) {
      if (v.cfg != null && v.cfg.clientIdList.contains(cid)) {
        if (v.cfg.gameServerId == k) {
          b = v.cfg.gameServerId;
        }
      }
    });
    return b;
  }

  OneGameData getGameDataByClientId(String cid) {
    OneGameData b;
    gameDatas.forEach((k, v) {
      if (b == null && v.cfg != null && v.cfg.clientIdList.contains(cid)) {
        if (v.cfg.gameServerId == k) {
          b = v;
        }
      }
    });
    return b;
  }

  // 获取背包电脑的矫正程序
  Monitor getPcAdjustMonitor(String pcId) {
    if (monitorPid.containsKey(pcId)) {
      var mid = monitorPid[pcId].key;
      var monitor = mid != 0 ? getMonitor(mid) : null;
      return monitor;
    }
    return null;
  }

  void test() {
    if (kReleaseMode) {
      return;
    }

    Timer.periodic(new Duration(seconds: 1), (t) {
      // 检查一下是否断线了
      var now = DateTime.now().millisecondsSinceEpoch;
      gameDatas.forEach((k, v) {
        if (v.lastRepTime != null &&
            v.lastRepTime > 0 &&
            (now - v.lastRepTime > Constants.MaxTimeoutMillisecond)) {
          v.dirty();
        }
      });

      // 设置设备是否在线
      gameDatas.forEach((k, v) {
        v.gameServer.hasProcess =
            Application.connection.getProcessOnline(v.gameServer.id);
        v.clients.forEach((k, v) {
          v.hasProcess = Application.connection.getProcessOnline(k);
        });
      });
    });
  }

  void startJob() {
    print('startjob');
    Timer.periodic(new Duration(milliseconds: 200), (t) {
      Application.transmit.sendMessage(
          IvrGrabHtsMessageType.GET_DEVICE_STATE.index,
          IvrGetDeviceState(timestamp: 0));
      if (Application.dataCenter.settingData.data.useYdl) {
        Application.tracker.sendMessage(
            IvrGrabHtsMessageType.GET_DEVICE_STATE.index,
            IvrGetDeviceState(timestamp: 0));
        if (Application.dataCenter.getForeground()) {
          Application.hardwareYDL.sendMessage('RegistIp');
          Application.hardwareYDL.sendMessage('GetHardwareOnline');
        }
      }

      int c = Application.dataCenter.sharing.getServerCount();
      for (int i = 0;i < c;i++){
        var tag = Application.dataCenter.sharing.getServerTag(i);
        Application.dataCenter.sharing.requestProgress(tag);
      }
//      Application.tracker.sendMessage(IvrGrabHtsMessageType.GET_REFLECT_STATE.index, IvrGetReflectState(timestamp: 0));
    });

    Timer.periodic(new Duration(milliseconds: 1000), (t) {
      int c = Application.dataCenter.sharing.getServerCount();
      for (int i = 0;i < c;i++){
        var tag = Application.dataCenter.sharing.getServerTag(i);
        Application.dataCenter.sharing.getOrCreateRoom(tag);
      }
    });
  }

  double getTrackerBattery(String deviceId) {
    var d = this;
    if (!d.hmdIdx.containsKey(deviceId)) {
      return -1;
    }

    var id = d.hmdIdx[deviceId];

    if (!d.trackers.containsKey(id)) {
      return -1;
    }

    if (d.trackers[id] == null) {
      return -1;
    }

    return d.trackers[id].battery;
  }

  bool isHmdMounted(String deviceId) {
    var d = this;
    if (!d.hmdIdx.containsKey(deviceId)) {
      return false;
    }

    var id = d.hmdIdx[deviceId];
    if (!d.hmds.containsKey(id)) {
      return false;
    }
    if (d.hmds[id] == null) {
      return false;
    }

    return d.hmds[id].mounted;
  }

  bool isHmdLosted(String deviceId) {
    var d = this;
    if (!d.hmdIdx.containsKey(deviceId)) {
      return false;
    }

    var id = d.hmdIdx[deviceId];
    if (!d.hmds.containsKey(id)) {
      return false;
    }
    if (d.hmds[id] == null) {
      return false;
    }

    return d.hmds[id].mounted == true && d.hmds[id].inputFocus == false;
  }

  double getTrackerBatteryWithMonitorId(int mid) {
    bool contains = false;
    String key = "";
    monitorPid.forEach((k, v) {
      if (v.key == mid) {
        contains = true;
        key = k;
      }
    });

    if (!contains) {
      return 0;
    }
    return getTrackerBattery(key);
  }

  bool isHmdMountedWithMonitorId(int mid) {
    bool contains = false;
    String key = "";
    monitorPid.forEach((k, v) {
      if (v.key == mid) {
        contains = true;
        key = k;
      }
    });

    if (!contains) {
      return false;
    }
    return isHmdMounted(key);
  }

  bool isHmdLostedWithMonitorId(int mid) {
    bool contains = false;
    String key = "";
    monitorPid.forEach((k, v) {
      if (v.key == mid) {
        contains = true;
        key = k;
      }
    });

    if (!contains) {
      return false;
    }
    return isHmdLosted(key);
  }

  double getPcBattery(String deviceId) {
    final Map<String, int> deviceIdToPcId = {
      "c1": 41,
      "c2": 42,
      "c3": 43,
      "c4": 44,
      "c5": 45,
      "c6": 46,
      "c7": 47,
      "c8": 48,
    };

    var id = deviceIdToPcId[deviceId] ?? 0;

    Monitor mon;

    Application.dataCenter.pcRelations.forEach((rel) {
      if (rel.type == DeviceType.MONITOR) {
        if (rel.id == id) {
          mon = Application.dataCenter.getMonitor(rel.id);
        }
      }
    });

    if (mon != null) {
      return mon.getBatterPercentage() / 100;
    }

    return 0;
  }
}
