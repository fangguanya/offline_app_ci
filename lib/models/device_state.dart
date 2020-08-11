import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/protocol/game_state.dart';

/**
 * Auth :   liubo
 * Date :   2019/9/22 22:20
 * Comment: 设备状态相关的
 */


class GameClientStateData extends IvrData {
  GameClientStateData({this.id,this.serverId});

  String id = '';
  String serverId = '';

  bool hasProcess = false; // 是否有游戏进程
  bool online = false;      // 是否与中控通信了
  bool hasPlayerId = false; // 是否设置过playerid
  bool blue = false;  // 是否到达蓝房子
  bool height = false;
  bool locator = false;
  bool using = false;

  int step = 0;
  double trackerBattery = 0;
  int avatar = 0;

  double percent = -1;
  double count = -1;
  bool adjusting = false;
  bool losingTracking = false;

  bool get isOnline {
    return online || hasProcess;
  }

  bool get inLeaveArea {
    return step == Constants.IdLevelArea;
  }
}

class GameServerStateData extends IvrData {
  String id;
  String gameName = "末日营救2071";

  bool hasProcess; // 是否有进程
  bool online;     // 是否与中控通信了

  int step = 0;
  int diff = 0;

  bool get isOnline {
    return online || hasProcess;
  }
}

// 一场游戏的数据
class OneGameData extends IvrData {
  OneGameData([String id]) {
    gameServer = GameServerStateData();
    gameServer.id = id;
  }

  void setGameFlag(int flag) {
    if(flag != gameFlag) {
      gameFlag = flag;
      dirty();
    }
  }

  bool get timeout {
    var now = DateTime.now().millisecondsSinceEpoch;
    if(lastRepTime != null && lastRepTime > 0 && (now - lastRepTime > Constants.MaxTimeoutMillisecond)) {
      return true;
    } else {
      return false;
    }
  }

  bool isPlaying() {
    return gameFlag == Constants.GameFlagGaming ||gameFlag == Constants.GameFlagReadyGo;
  }

  OneGameConfig cfg;
  List<String> desiredDeviceList;
  int lastRepTime = 0;
  int gameFlag = 0;
  int seatCount = 0;
  bool gameReady = false;
  GameServerStateData gameServer;
  Map<String, GameClientStateData> clients = Map<String, GameClientStateData>();
}







