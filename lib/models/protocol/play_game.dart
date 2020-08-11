/**
 * Auth :   liubo
 * Date :   2019/9/23 21:33
 * Comment: 设置游戏状态
 */

import 'dart:convert';

PlayGameInfo playGameInfoFromJson(String str) => PlayGameInfo.fromJson(json.decode(str));

String playGameInfoToJson(PlayGameInfo data) => json.encode(data.toJson());

class PlayGameInfo {
  List<String> clientIdList;
  int flag;
  String serverId;

  PlayGameInfo({
    this.clientIdList,
    this.flag,
    this.serverId,
  });

  factory PlayGameInfo.fromJson(Map<String, dynamic> json) => PlayGameInfo(
    clientIdList: List<String>.from(json["ClientIdList"].map((x) => x)),
    flag: json["Flag"].toInt(),
    serverId: json["ServerId"],
  );

  Map<String, dynamic> toJson() => {
    "ClientIdList": List<dynamic>.from(clientIdList.map((x) => x)),
    "Flag": flag,
    "ServerId": serverId,
  };
}
