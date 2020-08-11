/**
 * Auth :   liubo
 * Date :   2019/11/21 10:10
 * Comment: 协议定义
 *  使用工具：https://app.quicktype.io/
 */

import 'dart:convert';

OneGameConfig oneGameConfigFromJson(String str) => OneGameConfig.fromJson(json.decode(str));

String oneGameConfigToJson(OneGameConfig data) => json.encode(data.toJson());

OneGameListConfig oneGameListConfigFromJson(String str) => OneGameListConfig.fromJson(json.decode(str));

String oneGameListConfigToJson(OneGameListConfig data) => json.encode(data.toJson());

class OneGameListConfig {
  List<OneGameConfig> allGame;
  Map<String, double> hmdIdx;
  Map<String, double> monitorPid;
  Map<String, double> monitorPidIdx;
  double sdkMode;
  Map<String, double> weaponIdx;

  OneGameListConfig({
    this.allGame,
    this.hmdIdx,
    this.monitorPid,
    this.monitorPidIdx,
    this.sdkMode,
    this.weaponIdx,
  });

  factory OneGameListConfig.fromJson(Map<String, dynamic> json) => OneGameListConfig(
    allGame: List<OneGameConfig>.from(json["AllGame"].map((x) => OneGameConfig.fromJson(x))),
    hmdIdx: Map.from(json["HmdIdx"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
    monitorPid: Map.from(json["MonitorPid"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
    monitorPidIdx: Map.from(json["MonitorPidIdx"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
    sdkMode: json["SdkMode"].toDouble(),
    weaponIdx: Map.from(json["WeaponIdx"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "AllGame": List<dynamic>.from(allGame.map((x) => x.toJson())),
    "HmdIdx": Map.from(hmdIdx).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "MonitorPid": Map.from(monitorPid).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "MonitorPidIdx": Map.from(monitorPidIdx).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "SdkMode": sdkMode,
    "WeaponIdx": Map.from(weaponIdx).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class OneGameConfig {
  List<String> clientIdList;
  String gameServerId;
  List<double> seatId;

  OneGameConfig({
    this.clientIdList,
    this.gameServerId,
    this.seatId,
  });

  factory OneGameConfig.fromJson(Map<String, dynamic> json) => OneGameConfig(
    clientIdList: List<String>.from(json["ClientIdList"].map((x) => x)),
    gameServerId: json["GameServerId"],
    seatId: List<double>.from(json["SeatId"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "ClientIdList": List<dynamic>.from(clientIdList.map((x) => x)),
    "GameServerId": gameServerId,
    "SeatId": List<dynamic>.from(seatId.map((x) => x)),
  };
}
