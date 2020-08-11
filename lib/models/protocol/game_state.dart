/**
 * Auth :   liubo
 * Date :   2019/9/23 17:34
 * Comment: 协议定义
 *  使用工具：https://app.quicktype.io/
 */



import 'dart:convert';

double toDouble(dynamic a)
{
  if(a == null) {
    return 0;
  }

  if(a is int) {
    return a * 1.0;
  }

  if(a is double) {
    return a;
  }

  if(a is String) {
    return double.parse(a);
  }

  return 0;
}

GameStateProtocol gameStateProtocolFromJson(String str) => GameStateProtocol.fromJson(json.decode(str));

String gameStateProtocolToJson(GameStateProtocol data) => json.encode(data.toJson());

class GameStateProtocol {
  List<GameInfo> datas;
  Map<String, int> monitorPid;
  Map<String, int> monitorPidIdx;
  Map<String, int> seatStatus;
  Map<String, int> weaponIdx;
  Map<String, int> hmdIdx;

  GameStateProtocol({
    this.datas,
    this.monitorPid,
    this.monitorPidIdx,
    this.seatStatus,
    this.weaponIdx,
    this.hmdIdx,
  });

  factory GameStateProtocol.fromJson(Map<String, dynamic> json) => GameStateProtocol(
    datas: List<GameInfo>.from(json["Datas"].map((x) => GameInfo.fromJson(x))),
    monitorPid:  Map.from(json["MonitorPid"]).map((k,v) => MapEntry<String, int>(k, v)),
    monitorPidIdx:  Map.from(json["MonitorPidIdx"]).map((k,v) => MapEntry<String, int>(k, v)),
    seatStatus:  Map.from(json["SeatStatus"]).map((k,v) => MapEntry<String, int>(k, v)),
    weaponIdx:  Map.from(json["WeaponIdx"]).map((k,v) => MapEntry<String, int>(k, v)),
    hmdIdx:  Map.from(json["HmdIdx"]).map((k,v) => MapEntry<String, int>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "datas": List<dynamic>.from(datas.map((x) => x.toJson())),
    "MonitorPid": Map.from(monitorPid).map((k, v) => MapEntry<String, int>(k, v.toJson())),
    "MonitorPidIdx": Map.from(monitorPidIdx).map((k, v) => MapEntry<String, int>(k, v.toJson())),
    "SeatStatus": Map.from(seatStatus).map((k, v) => MapEntry<String, int>(k, v.toJson())),
    "WeaponIdx": Map.from(weaponIdx).map((k, v) => MapEntry<String, int>(k, v.toJson())),
    "HmdIdx": Map.from(hmdIdx).map((k, v) => MapEntry<String, int>(k, v.toJson())),
  };
}

class GameInfo {
  OneGameConfig cfg;
  Map<String, BaseDeviceState> allDeviceMetaList;
  List<String> desiredDeviceList;
  int gameFlag;
  int gameReady;
  int seatCount;

  GameInfo({
    this.cfg,
    this.allDeviceMetaList,
    this.desiredDeviceList,
    this.gameFlag,
    this.gameReady,
    this.seatCount,
  });

  factory GameInfo.fromJson(Map<String, dynamic> json) => GameInfo(
    cfg: OneGameConfig.fromJson(json["Cfg"]),
    allDeviceMetaList: Map.from(json["AllDeviceMetaList"]).map((k,v) => MapEntry<String, BaseDeviceState>(k, BaseDeviceState.fromJson(v))),
    desiredDeviceList: List<String>.from(json["DesiredDeviceList"].map((x) => x)),
    gameFlag: json["GameFlag"],
    gameReady: json["GameReady"],
    seatCount: json["SeatCount"],
  );

  Map<String, dynamic> toJson() => {
    "Cfg": cfg.toJson(),
    "AllDeviceMetaList": Map.from(allDeviceMetaList).map((k, v) => MapEntry<String, BaseDeviceState>(k, v.toJson())),
    "DesiredDeviceList": List<dynamic>.from(desiredDeviceList.map((x) => x)),
    "GameFlag": gameFlag,
    "GameReady": gameReady,
    "SeatCount": seatCount,
  };
}

class BaseDeviceState {
  String id;
  bool isOnlineFlag;
  bool playerIdDone;
  bool blueRoomDone;
  bool adjustHeightDone;

  int progress;
  int playerCnt;
  int avatar = 0;

  double percent = 0;
  double count = 0;
  bool adjusting = false;
  bool losingTracking = false;
  int diff;

  BaseDeviceState({
    this.id,
    this.isOnlineFlag,
    this.playerIdDone,
    this.blueRoomDone,
    this.adjustHeightDone,
    this.progress,
    this.playerCnt,
    this.avatar,

    this.percent,
    this.count,
    this.adjusting,
    this.losingTracking,

    this.diff
  });

  factory BaseDeviceState.fromJson(Map<String, dynamic> json) => BaseDeviceState(
    id: json["Id"],
    isOnlineFlag: json["IsOnlineFlag"],
    playerIdDone: json["PlayerIdDone"],
    blueRoomDone: json["BlueRoomDone"],
    adjustHeightDone: json["AdjustHeightDone"],
    progress: json["Progress"],
    playerCnt: json["PlayerCnt"],
    avatar: json["Avatar"],

    percent: toDouble(json["Percent"]),
    count: toDouble(json["Count"]),
    adjusting: json["Adjusting"],
    losingTracking: json["LosingTracking"],

    diff: json["Diff"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "IsOnlineFlag": isOnlineFlag,
    "PlayerIdDone": playerIdDone,
    "BlueRoomDone": blueRoomDone,
    "AdjustHeightDone": adjustHeightDone,
    "Progress": progress,
    "PlayerCnt": playerCnt,
    "Avatar": avatar,

    "Percent": percent,
    "Count": count,
    "Adjusting": adjusting,
    "LosingTracking": losingTracking,
    "Diff": diff,
  };
}

class OneGameConfig {
  String gameServerId;
  List<String> clientIdList;
  List<int> seatId;

  OneGameConfig({
    this.gameServerId,
    this.clientIdList,
    this.seatId,
  });

  factory OneGameConfig.fromJson(Map<String, dynamic> json) => OneGameConfig(
    gameServerId: json["GameServerId"],
    clientIdList: List<String>.from(json["ClientIdList"].map((x) => x)),
    seatId: List<int>.from(json["SeatId"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "GameServerId": gameServerId,
    "ClientIdList": List<dynamic>.from(clientIdList.map((x) => x)),
    "SeatId": List<dynamic>.from(seatId.map((x) => x)),
  };
}


// 操作设备

OperateDeviceMsg operateDeviceMsgFromJson(String str) => OperateDeviceMsg.fromJson(json.decode(str));

String operateDeviceMsgToJson(OperateDeviceMsg data) => json.encode(data.toJson());

class OperateDeviceMsg {
  String deviceId;
  int flag;
  int operate;

  OperateDeviceMsg({
    this.deviceId,
    this.flag,
    this.operate,
  });

  factory OperateDeviceMsg.fromJson(Map<String, dynamic> json) => OperateDeviceMsg(
    deviceId: json["deviceId"],
    flag: json["flag"],
    operate: json["operate"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "flag": flag,
    "operate": operate,
  };
}

// 更换形象
AvatarInfo avatarInfoFromJson(String str) => AvatarInfo.fromJson(json.decode(str));

String avatarInfoToJson(AvatarInfo data) => json.encode(data.toJson());

class AvatarInfo {
  int avatarId;
  String clientId;

  AvatarInfo({
    this.avatarId,
    this.clientId,
  });

  factory AvatarInfo.fromJson(Map<String, dynamic> json) => AvatarInfo(
    avatarId: json["AvatarId"],
    clientId: json["ClientId"],
  );

  Map<String, dynamic> toJson() => {
    "AvatarId": avatarId,
    "ClientId": clientId,
  };
}

// 开始校准
AdjustPositionInfo adjustPositionInfoFromJson(String str) => AdjustPositionInfo.fromJson(json.decode(str));

String adjustPositionInfoToJson(AdjustPositionInfo data) => json.encode(data.toJson());

class AdjustPositionInfo {
  int adjust;
  String clientId;

  AdjustPositionInfo({
    this.adjust,
    this.clientId,
  });

  factory AdjustPositionInfo.fromJson(Map<String, dynamic> json) => AdjustPositionInfo(
    adjust: json["Adjust"],
    clientId: json["ClientId"],
  );

  Map<String, dynamic> toJson() => {
    "Adjust": adjust,
    "ClientId": clientId,
  };
}

// 修改难度
ModifyDifficultyInfo modifyDifficultyInfoFromJson(String str) => ModifyDifficultyInfo.fromJson(json.decode(str));

String modifyDifficultyInfoToJson(ModifyDifficultyInfo data) => json.encode(data.toJson());

class ModifyDifficultyInfo {
  int diff;
  String serverId;

  ModifyDifficultyInfo({
    this.diff,
    this.serverId,
  });

  factory ModifyDifficultyInfo.fromJson(Map<String, dynamic> json) => ModifyDifficultyInfo(
    diff: json["Diff"],
    serverId: json["ServerId"],
  );

  Map<String, dynamic> toJson() => {
    "Diff": diff,
    "ServerId": serverId,
  };
}


