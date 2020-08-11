import 'package:operator_controller/models/device/types.dart';
import 'dart:convert';

// 协议定义常量
class Protocol {
  // 消息定义
  static const TopicsOperateWorkerAppLaunch = "TOPICS/OPERATE/WORKER/APPLAUNCH";
  static const TopicsOperateWorkerConfigs =
      "TOPICS/OPERATE/WORKER/CONFIGS"; // 设备的配置信息列表
  static const TopicsOperateWorkerConfig =
      "TOPICS/OPERATE/WORKER/CONFIG"; // 设备从服务器请求配置信息
  static const TopicsOperateWorkerRelationConfigs =
      "TOPICS/OPERATE/WORKER/RELATION/CONFIGS"; // 硬件的映射信息配置列表
  static const TopicsOperateWorkerRun =
      "TOPICS/OPERATE/WORKER/RUN"; // 服务器指定设备执行程序
  static const TopicsOperateWorkerRunResult =
      "TOPICS/OPERATE/WORKER/RUNRESULT"; // 服务器指定设备执行程序
  static const TopicsOperateWorkerWatchList =
      "TOPICS/OPERATE/WORKER/WATCHLIST"; // 指定监控的进程列表
  static const TopicsOperateWorkerWatchStatus =
      "TOPICS/OPERATE/WORKER/WATCHSTATUS"; // 监控的进程状态
  static const TopicGameAllConfig = "TOPICS/Game/AllConfig"; // 游戏配置
  static const TopicGameState = "TOPICS/Game/AllState"; // 游戏状态
  static const TopicGameSetGameFlag = "TOPICS/Game/SetGameFlag"; // 游戏状态
  static const TopicGameAppendClient =
      "TOPICS/Game/TopicGameAppendClient"; // 游戏状态
  static const TopicGameOperateDevice =
      "TOPICS/Game/TopicGameOperateDevice"; // 游戏状态
  static const TopicGameChangeAvatar = "TOPICS/Game/ChangeAvatar"; // 游戏状态
  static const TopicGameAdjust = "TOPICS/Game/Adjust"; // 游戏状态
  static const TopicGameModifyDiff = "TOPICS/Game/ModifyDiff"; // 游戏状态
  static const TopicsOperateConfigRotatorReset =
      "TOPICS/OPERATE/CONFIG/ROTATOR/RESET"; // 陀螺仪角度重置

  // 硬件消息
  static const TopicsVibrateAudio = "TOPICS/WRITE/VIBRATE/AUDIO"; // 坐垫震动模块
  static const TopicsWriteAudio = "TOPICS/WRITE/AUDIO"; // 一次震动
  static const TopicsElevatorVibrate =
      "TOPICS/WRITE/ELEVATOR/VIBRATE"; // 控制电梯震动
  static const TopicsFan = "TOPICS/WRITE/FAN"; // 控制风扇旋转

  static const TopicsClose = "TOPICS/CLOSE";

  // 控制定位模式
  static const TopicsOperateConfigGameRemoteSet =
      "TOPICS/OPERATE/CONFIG/GAME/REMOTEADD/SET";
  static const TopicsOperateConfigGameRemoteGet =
      "TOPICS/OPERATE/CONFIG/GAME/REMOTEADD/GET";
  static const TopicsOperateConfigGameRemoteGetResult =
      "TOPICS/OPERATE/CONFIG/GAME/REMOTEADD/GET/RESULT";

  // 硬件状态同步
  // 硬件/设备状态提交 : xx(ms)固定推送1次,前端自动根据超时机制控制
  static const TopicsOperateHardwareState = "TOPICS/OPERATE/HARDWARE/STATE";

  // HTC追踪器等状态的更新
  static const TopicsOperateTrackerState = "TOPICS/OPERATE/TRACKER/STATE";

  // 校准坐标系消息
  static const TopicsOperateCalibrationBegin =
      "TOPICS/OPERATE/CALIBRATION/START";
  static const TopicsOperateCalibrationEnd = "TOPICS/OPERATE/CALIBRATION/END";
  static const TopicsOperateGenerateTracking =
      "TOPICS/OPERATE/GENERATE/TRACKING";

  // ALT校准坐标系消息
  static const TopicsOperateAltGenerateSpace =
      "TOPICS/OPERATE/ALT/GENERATE/SPACE";

  //
  // 注意:以下为社交分享视频录制功能协议
  //
  // 创建房间(队伍)
  static const TopicsSocializeTeamCreate = "TOPICS/SOCIALIZE/TEAM/CREATE";
  static const TopicsSocializeTeamGetOrCreate =
      "TOPICS/SOCIALIZE/TEAM/GETORCREATE";
  static const TopicsSocializeTeamFinish = "TOPICS/SOCIALIZE/TEAM/FINISH";

  // 开始录制材料
  static const TopicsSocializeTeamRunRecord = "TOPICS/SOCIALIZE/TEAM/RUNRECORD";
  static const TopicsSocializeTeamRunRecordProgressGet =
      "TOPICS/SOCIALIZE/TEAM/RUNRECORD/PROGRESS/GET";
  static const TopicsSocializeTeamRunRecordProgressResult =
      "TOPICS/SOCIALIZE/TEAM/RUNRECORD/PROGRESS/RESULT";

  // 请求队伍得照片列表
  static const TopicsSocializeTeamPhotoList = "TOPICS/SOCIALIZE/TEAM/PHOTOLIST";
  static const TopicsSocializeTeamPhotoListResult =
      "TOPICS/SOCIALIZE/TEAM/PHOTOLISTRESULT";

  // 选定队伍照片
  static const TopicsSocializeTeamPhotoSel = "TOPICS/SOCIALIZE/TEAM/PHOTOSEL";

  // 拍摄队伍照片
  static const TopicsSocializeTeamPhotoTake = "TOPICS/SOCIALIZE/TEAM/PHOTOTAKE";

  // 请求个人得照片列表
  static const TopicsSocializePlayerPhotoList =
      "TOPICS/SOCIALIZE/PLAYER/PHOTOLIST";
  static const TopicsSocializePlayerPhotoListResult =
      "TOPICS/SOCIALIZE/PLAYER/PHOTOLISTRESULT";

  // 选定个人照片
  static const TopicsSocializePlayerPhotoSel =
      "TOPICS/SOCIALIZE/PLAYER/PHOTOSEL";

  // 拍摄个人照片
  static const TopicsSocializePlayerPhotoTake =
      "TOPICS/SOCIALIZE/PLAYER/PHOTOTAKE";

  // 设置玩家信息
  static const TopicsSocializePlayerInfoSet =
      "TOPICS/SOCIALIZE/PLAYER/INFO/SET";

  // 选择游戏
  static const TopicsSocializeTeamGameSelect =
      "TOPICS/SOCIALIZE/TEAM/GAME/SELECT";

  // 属性获取
  static const TopicsSocializeTeamInfoSet = "TOPICS/SOCIALIZE/TEAMINFO/SET";
  static const TopicsSocializeTeamInfoGet = "TOPICS/SOCIALIZE/TEAMINFO/GET";
  static const TopicsSocializeTeamInfoGetResult =
      "TOPICS/SOCIALIZE/TEAMINFO/GETRESULT";
}

class RunnerResult {
  ExecutionType action;
  int id;
  int code;
  String result;
  String exec;

  RunnerResult({this.exec, this.result, this.id, this.code, this.action});

  factory RunnerResult.fromJson(Map<String, dynamic> json) {
    return RunnerResult(
        result: json["result"],
        id: json["id"],
        code: json["code"],
        exec: json["exec"],
        action: ExecutionType(json["action"]));
  }
}

class WorkerWatcher {
  String exec; // 可执行程序的完整路径
  WorkerWatcher({this.exec});
  factory WorkerWatcher.fromJson(Map<String, dynamic> json) {
    return WorkerWatcher(exec: json["exec"]);
  }
}

class WorkerRunner {
  String exec; // 可执行程序"完整路径"
  List<String> args; // 程序的启动参数
  List<String> envs; // 环境变量定义

  WorkerRunner({this.exec, this.args, this.envs});

  factory WorkerRunner.fromJson(Map<String, dynamic> json) {
    var originList1 = json["env"];
    var originList2 = json["arg"];
    List<String> envs = new List<String>.from(originList1);
    List<String> args = new List<String>.from(originList2);
    return WorkerRunner(exec: json["exec"], args: args, envs: envs);
  }

  Map<String, dynamic> toJson() => {
        'exec': exec,
        'arg': args,
        'env': envs,
      };
}

class WorkerConfig {
  List<WorkerWatcher> watcher;
  List<WorkerRunner> runner;
  String name;
  String ip;
  int id;
  bool online;

  WorkerConfig(
      {this.watcher, this.runner, this.name, this.ip, this.id, this.online});

  factory WorkerConfig.fromJson(Map<String, dynamic> json) {
    var originalList1 = json["watcher"] as List;
    var originalList2 = json["runner"] as List;
    List<WorkerWatcher> watcher =
        originalList1.map((value) => WorkerWatcher.fromJson(value)).toList();
    List<WorkerRunner> runner =
        originalList2.map((value) => WorkerRunner.fromJson(value)).toList();
    return WorkerConfig(
        watcher: watcher,
        runner: runner,
        name: json["name"],
        ip: json["ip"],
        id: json["id"],
        online: json["online"]);
  }
}

class WatchStatus {
  bool status;
  WorkerWatcher process;

  WatchStatus({this.status, this.process});

  factory WatchStatus.fromJson(Map<String, dynamic> json) {
    return WatchStatus(
        status: json["status"],
        process: WorkerWatcher.fromJson(json["process"]));
  }
}

class RunCommand {
  WorkerRunner cmd;
  int action; // 1:启动,2:停止,3:重启
  RunCommand({this.cmd, this.action});
  Map<String, dynamic> toJson() => {
        'cmd': cmd,
        'action': action,
      };
}

class GenerateTracking {
  int id;
  GenerateTracking({this.id});
  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class WatchStatusList {
  int id;
  List<WatchStatus> list;

  WatchStatusList({this.list, this.id});

  factory WatchStatusList.fromJson(Map<String, dynamic> json) {
    var originallist = json["list"] as List;
    if (originallist != null) {
      return WatchStatusList(
          id: json["id"],
          list: originallist
              .map((value) => WatchStatus.fromJson(value))
              .toList());
    } else {
      return WatchStatusList(id: json["id"], list: new List<WatchStatus>());
    }
  }
}

class WorkerList {
  List<WorkerConfig> list;

  WorkerList({this.list});

  factory WorkerList.fromJson(Map<String, dynamic> json) {
    var originallist = json["list"] as List;
    return WorkerList(
        list:
            originallist.map((value) => WorkerConfig.fromJson(value)).toList());
  }
}

class WorkerRelation {
  String name; // 显示的名称
  DeviceType type; // 映射的设备类型
  int id; // 映射的设备id
  int ydlid; // 映射的影动力id
  String param; // 请求执行时的参数
  bool exec; // 该设备是否有行为可运行
  bool visible;
  WorkerRelation(
      {this.name,
      this.type,
      this.id,
      this.param,
      this.exec,
      this.visible,
      this.ydlid});
  factory WorkerRelation.fromJson(Map<String, dynamic> json) {
    return WorkerRelation(
        name: json["name"],
        id: json["id"],
        param: json["param"],
        type: DeviceType(json["type"]),
        exec: json["exec"],
        ydlid: json["ydlid"],
        visible: json["visible"]);
  }
}

class RelationList {
  List<WorkerRelation> hdlist;
  List<WorkerRelation> pclist;
  RelationList({this.hdlist, this.pclist});
  factory RelationList.fromJson(Map<String, dynamic> json) {
    var originallist1 = json["hdlist"] as List;
    var originallist2 = json["pclist"] as List;
    return RelationList(
        hdlist: originallist1
            .map((value) => WorkerRelation.fromJson(value))
            .toList(),
        pclist: originallist2
            .map((value) => WorkerRelation.fromJson(value))
            .toList());
  }
}

class ConfigRemoteConfigSet {
  int status; // 当前使用的校准方式
  ConfigRemoteConfigSet({this.status});
  Map<String, dynamic> toJson() => {
        'status': status,
      };
}

class ConfigRemoteConfig {
// 服务器同步过来数据收集服务器得ip/port
  String trackingip;
  int trackingport;
  String transmitip;
  int transmitport;
  int status; // 当前使用的校准方式
  ConfigRemoteConfig(
      {this.trackingip,
      this.trackingport,
      this.transmitip,
      this.transmitport,
      this.status});
  factory ConfigRemoteConfig.fromJson(Map<String, dynamic> json) {
    return ConfigRemoteConfig(
        trackingip: json["trackingip"],
        trackingport: json["trackingport"],
        transmitip: json["transmitip"],
        transmitport: json["transmitport"],
        status: json["status"]);
  }
}

// 电梯
class ElevatorInfo {
  int id;
  int level;
  int state;
  ElevatorInfo({this.id, this.level, this.state});
  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'state': state,
      };
}

// 音频震动
class VibrateInfo {
  int id; // 当前设备ID
  int channel; // 播放的channel
  int index; // 播放第几首wav
  int state; // 播放/停止
  VibrateInfo({this.id, this.channel, this.index, this.state});
  Map<String, dynamic> toJson() => {
        'id': id,
        'channel': channel,
        'index': index,
        'state': state,
      };
}

// 风扇
class FanInfo {
  int id; // 当前设备ID
  int index; // 继电器索引
  int state; // 接通/断开
  FanInfo({this.id, this.index, this.state});
  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'state': state,
      };
}

// 状态同步
// 注意 : 机器的Id和Type由Configure配置,而HTC设备的由映射决定
class HardwareState {
  // 设备状态
  DeviceStateType state;
  // 状态数值 : 根据type的不同,意义不同
  int value;
  // 附加数值(再有需要的话,就单独定协议算了)
  int extra;
  HardwareState({this.state, this.value, this.extra});
  factory HardwareState.fromJson(Map<String, dynamic> json) {
    return HardwareState(
        state: DeviceStateType(json["state"]),
        extra: json["extra"],
        value: json["value"]);
  }
}

class HardwareStateUpdate {
  // 设备ID
  int id;
  // 设备类型
  DeviceType type;
  // 状态属性列表
  List<HardwareState> stats;
  HardwareStateUpdate({this.id, this.type, this.stats});
  factory HardwareStateUpdate.fromJson(Map<String, dynamic> json) {
    var originallist = json["stats"] as List;
    return HardwareStateUpdate(
        id: json["id"],
        type: DeviceType(json["type"]),
        stats: originallist
            .map((value) => HardwareState.fromJson(value))
            .toList());
  }
}

// 注意 : 对HTC的基站和tracker使用单独的协议,因为下一期需要添加app中设定设备ID映射
class TrackerDeviceState {
  // 设备ID
  int id;
  // 设备序列号
  String serial;
  // 设备是否开机
  int on;
  // 设备类型
  HtcDeviceType type;
  TrackerDeviceState({this.id, this.serial, this.on, this.type});
  factory TrackerDeviceState.fromJson(Map<String, dynamic> json) {
    return TrackerDeviceState(
        id: json["id"],
        serial: json["serial"],
        on: json["on"],
        type: HtcDeviceType(json["type"]));
  }
}

class TrackerDeviceStateUpdate {
  // 设备列表
  List<TrackerDeviceState> devices;
  TrackerDeviceStateUpdate({this.devices});
  factory TrackerDeviceStateUpdate.fromJson(Map<String, dynamic> json) {
    var originallist = json["devices"] as List;
    return TrackerDeviceStateUpdate(
        devices: originallist
            .map((value) => TrackerDeviceState.fromJson(value))
            .toList());
  }
}

// 坐标系校准开始
class CalibrationBegin {
  // 校准的背包电脑ID
  int id;
  CalibrationBegin({this.id});
  factory CalibrationBegin.fromJson(Map<String, dynamic> json) {
    return CalibrationBegin(id: json["id"]);
  }
}

// 坐标系校准完结
class CalibrationEnd {
  // 校准背包电脑ID
  int id;
  // 校准结果 : 没有错误=0
  int result;
  CalibrationEnd({this.id, this.result});
  factory CalibrationEnd.fromJson(Map<String, dynamic> json) {
    return CalibrationEnd(id: json["id"], result: json["result"]);
  }
}

// 链接中转数据服务器得协议配置
enum IvrDeviceType {
  DEV_PLAYER, // 头显
  DEV_WEAPON, // 武器
  DEV_NULL, // 暂时未使用.
}
enum IvrGrabHtsMessageType {
  // 同步时间戳
  SYNC_TIMESTAMP, // 注意:只有发送了该协议,服务器才会broadcast所有姿态数据过去!
  // 取得HTC设备的predict帧位置
  //DEFINATE_DEVICEFRAME,
  // 设定RIFTS锚点
  SET_RIFTSPACE,
  // 获取RISTS锚点
  GET_RIFTSPACE,
  // 获取HTC序列号列表
  GET_HTCSERIALS,
  // 设置HTC序列号映射
  SET_HTCSERIAL_REFLECTION,
  // 获取锚点列表
  GET_ANCHORS,

  // 上报设备朝向数据
  REPORT_DEVICE_ROTATION,
  REPORT_DEVICE_EULER,

  /**
   * 上面得协议内部使用,这里得为APP可能收到得数据
   */
  // 上报设备状态数据
  COLLECT_TRACKER_STATE,
  COLLECT_DEVICE_STATE,
  GET_DEVICE_STATE, // JSON
  GET_REFLECT_STATE1, // JSON
  GET_REFLECT_STATE, // JSON
  SET_REFLECT_STATE1, // JSON
  SET_REFLECT_STATE, // JSON
  COLLECT_HMDMOUNT_STATE,
  COLLECT_HMDAPP_STATE,

  FRAME,
}

class IvrTrackerStatus {
// 玩家定位器是否定位
  int id;
  bool tracked;
  double battery;
  IvrTrackerStatus({this.id, this.tracked, this.battery});
  factory IvrTrackerStatus.fromJson(Map<String, dynamic> json) {
    return IvrTrackerStatus(
        id: json["id"], tracked: json["tracked"], battery: json["battery"]);
  }
}

class IvrGetDeviceState {
  // 占位符...(自带的JSON工具不能处理空结构体)!
  double timestamp;
  IvrGetDeviceState({this.timestamp});
  factory IvrGetDeviceState.fromJson(Map<String, dynamic> json) {
    return IvrGetDeviceState(timestamp: json["timestamp"]);
  }
  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
      };
}

class IvrHtcVector3f {
  double x, y, z;
  IvrHtcVector3f({this.x, this.y, this.z});
  factory IvrHtcVector3f.fromJson(Map<String, dynamic> json) {
    return IvrHtcVector3f(x: json["x"], y: json["y"], z: json["z"]);
  }
}

class IvrHtcEulerf {
  double pitch, yaw, roll;
  IvrHtcEulerf({this.pitch, this.yaw, this.roll});
  factory IvrHtcEulerf.fromJson(Map<String, dynamic> json) {
    return IvrHtcEulerf(
        pitch: json["pitch"], yaw: json["yaw"], roll: json["roll"]);
  }
}

class IvrDeviceTransform {
  IvrDeviceType type;
  int id;
  // 统一为htc的坐标系!
  // 校准后的位置
  IvrHtcVector3f hybridPosition;
  IvrHtcEulerf hybridRotation;
  // HTC的位置
  IvrHtcVector3f htcPosition;
  IvrHtcEulerf htcRotation;
  IvrDeviceTransform(
      {this.type,
      this.id,
      this.hybridPosition,
      this.hybridRotation,
      this.htcPosition,
      this.htcRotation});
  factory IvrDeviceTransform.fromJson(Map<String, dynamic> json) {
    return IvrDeviceTransform(
      type: IvrDeviceType.values[json["type"]],
      id: json["id"],
      hybridPosition: IvrHtcVector3f.fromJson(json["hybridPosition"]),
      hybridRotation: IvrHtcEulerf.fromJson(json["hybridRotation"]),
      htcPosition: IvrHtcVector3f.fromJson(json["htcPosition"]),
      htcRotation: IvrHtcEulerf.fromJson(json["htcRotation"]),
    );
  }
}

class IvrHMDStatus {
  int id;
  bool mounted;
  bool vrFocus;
  bool inputFocus;
  IvrHMDStatus({this.id, this.mounted, this.vrFocus, this.inputFocus});
  factory IvrHMDStatus.fromJson(Map<String, dynamic> json) {
    return IvrHMDStatus(
      id: json["id"],
      mounted: json["mounted"],
      vrFocus: json["vrFocus"],
      inputFocus: json["inputFocus"],
    );
  }
}

class IvrGetDeviceStateResult {
  // 玩家定位器是否定位
  Map<int, IvrTrackerStatus> trackers;
  // 所有的定位位置信息
  Map<int, IvrDeviceTransform> devices;
  // 玩家oculus状态
  Map<int, IvrHMDStatus> hmds;
  IvrGetDeviceStateResult({this.trackers, this.devices, this.hmds});
  factory IvrGetDeviceStateResult.fromJson(Map<String, dynamic> json) {
    var originallist1 = json["trackers"] as List<dynamic>;
    var tmptrackers = Map<int, IvrTrackerStatus>();
    originallist1.forEach((k) {
      int key = k["key"];
      var value = IvrTrackerStatus.fromJson(k["value"]);
      tmptrackers[key] = value;
    });
    var originallist2 = json["devices"] as List<dynamic>;
    var tmpdevices = Map<int, IvrDeviceTransform>();
    originallist2.forEach((k) {
      int key = k["key"];
      var value = IvrDeviceTransform.fromJson(k["value"]);
      tmpdevices[key] = value;
    });
    var originallist3 = json["hmds"] as List<dynamic>;
    var tmphmds = Map<int, IvrHMDStatus>();
    originallist3?.forEach((k) {
      int key = k["key"];
      var value = IvrHMDStatus.fromJson(k["value"]);
      tmphmds[key] = value;
    });

    return IvrGetDeviceStateResult(
      trackers: tmptrackers,
      devices: tmpdevices,
      hmds: tmphmds,
    );
  }
}

// 请求和设置设备序列号映射
class IvrGetReflectState {
// 占位符...(自带的JSON工具不能处理空结构体)!
  double timestamp;
  IvrGetReflectState({this.timestamp});
  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
      };
}

class IvrGetReflectStateResult {
// 设备的ID映射
  Map<String, int> reflects;
  IvrGetReflectStateResult({this.reflects});
  factory IvrGetReflectStateResult.fromJson(Map<String, dynamic> json) {
    var originallist2 = json["reflects"] as List<dynamic>;
    var tmpreflects = Map<String, int>();
    originallist2.forEach((k) {
      String key = k["key"];
      int value = k["value"];
      tmpreflects[key] = value;
    });
    return IvrGetReflectStateResult(reflects: tmpreflects);
  }
}

class IvrSetReflectState {
  String serial;
  int id;
  IvrSetReflectState({this.serial, this.id});
  Map<String, dynamic> toJson() => {
        'serial': serial,
        'id': id,
      };
}

/**
 * 视频分享相关的功能
 *  - 包含基本的房间/角色信息同步
 *  - 包含不同协议的S2A/A2S请求和返回
 *  - 注意:所有视频分享的请求PROTOCOL均为=MQTT / s1{服务器轮次的tag
 */
// 玩家信息
class IvrSocializePlayerInfo {
  int id; // 唯一ID,暂时没有处理玩家第二次进入,仅作为同一次社交分享视频的生成索引
  bool valid; // 是否有玩家?
  String nickname; // 昵称,随意起的
  String coverimg; // 图片的链接地址
  List<String> images; // 所有拍摄了的照片列表
  int gender; // 0:不清楚,1:男,2:女
  int age; // 0:不清楚,---
  int gamepcid; // 映射的背包电脑ID
  int gameplayerid; // 映射的游戏内玩家ID
  String videourl15; // 15秒专属社交分享视频链接
  String videourl30; // 30秒专属社交分享视频链接

  IvrSocializePlayerInfo(
      {this.id,
      this.valid,
      this.nickname,
      this.coverimg,
      this.images,
      this.gender,
      this.age,
      this.gamepcid,
      this.gameplayerid,
      this.videourl15,
      this.videourl30});
  factory IvrSocializePlayerInfo.fromJson(Map<String, dynamic> json) {
    var originList1 = json["images"];
    List<String> images = new List<String>.from(originList1);
    return IvrSocializePlayerInfo(
      id: json["id"],
      valid: json["valid"],
//      nickname: utf8.decode(json["nickname"].runes.toList()),
      nickname: json["nickname"],
      coverimg: json["coverimg"],
      images: images,
      gender: json["gender"],
      age: json["age"],
      gamepcid: json["gamepcid"],
      gameplayerid: json["gameplayerid"],
      videourl15: json["videourl15"],
      videourl30: json["videourl30"],
    );
  }
}

// 房间信息
class IvrSocializeTeamInfo {
  int id; // 唯一ID
  String selectedgame; // 游戏名称,根据不同得游戏名称启动不同得视频生成进程
  List<IvrSocializePlayerInfo> players; // 本团队得所有成员信息
  int validplayercount; // 参与的玩家数目
  String coverimg; // 团队合影封面
  List<String> images; // 所有拍摄了的照片列表
  String nickname; // 团队名称(飞虎队什么得)
  String videourl15; // 15秒专属社交分享视频链接
  String videourl30; // 30秒专属社交分享视频链接

  IvrSocializeTeamInfo(
      {this.id,
      this.selectedgame,
      this.players,
      this.validplayercount,
      this.coverimg,
      this.images,
      this.nickname,
      this.videourl15,
      this.videourl30});
  factory IvrSocializeTeamInfo.fromJson(Map<String, dynamic> json) {
    var originList1 = json["images"];
    List<String> images = new List<String>.from(originList1);

    var originList2 = json["players"] as List<dynamic>;
    List<IvrSocializePlayerInfo> players = new List<IvrSocializePlayerInfo>();
    originList2.forEach((k) {
      players.add(IvrSocializePlayerInfo.fromJson(k));
    });

    return IvrSocializeTeamInfo(
      id: json["id"],
      selectedgame: json["selectedgame"],
      players: players,
      validplayercount: json["validplayercount"],
      coverimg: json["coverimg"],
      images: images,
//      nickname: utf8.decode(json["nickname"].runes.toList()),
      nickname: json["nickname"],
      videourl15: json["videourl15"],
      videourl30: json["videourl30"],
    );
  }
}

// 选择游戏
class A2S_GameSelect {
  String game;
  A2S_GameSelect({this.game});
  Map<String, dynamic> toJson() => {
        'game': game,
      };
}

// 返回进度信息
class S2A_RunGenerateProgress {
  int PrereqFinishCount;
  int PrereqTotalCount;
  int PlayerFinishCount;
  int PlayerTotalCount;
  S2A_RunGenerateProgress(
      {this.PrereqFinishCount,
      this.PrereqTotalCount,
      this.PlayerFinishCount,
      this.PlayerTotalCount});
  factory S2A_RunGenerateProgress.fromJson(Map<String, dynamic> json) {
    return S2A_RunGenerateProgress(
      PrereqFinishCount: json["PrereqFinishCount"],
      PrereqTotalCount: json["PrereqTotalCount"],
      PlayerFinishCount: json["PlayerFinishCount"],
      PlayerTotalCount: json["PlayerTotalCount"],
    );
  }
}

// 返回队伍照片信息
class S2A_TeamPhotosResult {
  List<String> images;
  String selected;
  S2A_TeamPhotosResult({this.images, this.selected});
  factory S2A_TeamPhotosResult.fromJson(Map<String, dynamic> json) {
    var originList1 = json["images"];
    List<String> images = new List<String>.from(originList1);
    return S2A_TeamPhotosResult(
      images: images,
      selected: json["selected"],
    );
  }
}

// 请求队伍照片的选取
class A2S_TeamPhotoSelect {
  String cover;
  A2S_TeamPhotoSelect({this.cover});
  Map<String, dynamic> toJson() => {
        'cover': cover,
      };
}

// 请求拍照
class A2S_TeamPhotoTake {
  String photo;
  A2S_TeamPhotoTake({this.photo});
  Map<String, dynamic> toJson() => {
        'photo': photo,
      };
}

// 返回玩家照片信息
class A2S_PlayerPhotos {
  int index;
  A2S_PlayerPhotos({this.index});
  Map<String, dynamic> toJson() => {
        'index': index,
      };
}

class S2A_PlayerPhotosResult {
  int index;
  List<String> images;
  String selected;
  S2A_PlayerPhotosResult({this.index, this.images, this.selected});
  factory S2A_PlayerPhotosResult.fromJson(Map<String, dynamic> json) {
    var originList1 = json["images"];
    List<String> images = new List<String>.from(originList1);
    return S2A_PlayerPhotosResult(
      index: json["index"],
      images: images,
      selected: json["selected"],
    );
  }
}

// 请求玩家照片的选取
class A2S_PlayerPhotoSelect {
  int index;
  String cover;
  A2S_PlayerPhotoSelect({this.index, this.cover});
  Map<String, dynamic> toJson() => {
        'index': index,
        'cover': cover,
      };
}

// 请求拍照
class A2S_PlayerPhotoTake {
  int index;
  String photo;
  A2S_PlayerPhotoTake({this.index, this.photo});
  Map<String, dynamic> toJson() => {
        'index': index,
        'photo': photo,
      };
}

// 设置玩家信息
class A2S_PlayerInfoSet {
  int index;
  String nickname;
  int gender;
  int age;
  int pc;
  bool valid;
  A2S_PlayerInfoSet(
      {this.index, this.nickname, this.gender, this.age, this.pc, this.valid});
  Map<String, dynamic> toJson() => {
        'index': index,
        'nickname': String.fromCharCodes(utf8.encode(nickname)),
        'gender': gender,
        'age': age,
        'pc': pc,
        'valid': valid,
      };
}

// 设置队伍信息
class A2S_TeamInfoSet {
  String nickname;
  A2S_TeamInfoSet({this.nickname});
  Map<String, dynamic> toJson() => {
        'nickname': String.fromCharCodes(utf8.encode(nickname)),
      };
}

// 上传图片返回结果
class HttpUploadPhotoResult {
  bool success; // 是否成功
  String url; // 保存的URL
  String error; // 失败的字符串
  HttpUploadPhotoResult({this.success, this.url, this.error});
  factory HttpUploadPhotoResult.fromJson(Map<String, dynamic> json) {
    return HttpUploadPhotoResult(
      success: json["success"],
      url: json["url"],
      error: json["error"],
    );
  }
}
