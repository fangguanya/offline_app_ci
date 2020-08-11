import 'dart:async';
import 'dart:convert';

import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/core/event_bus.dart';

import 'constants.dart';
import 'package:flutter/foundation.dart';

class SharingGenerateProgress {
  int PrereqFinishCount;
  int PrereqTotalCount;
  int PlayerFinishCount;
  int PlayerTotalCount;
}

// 视频录制的逻辑处理
class Sharing {
  // TODO:注意:目前发现服务器的tag: s1, s2是在代码中写死的,未来如果有需要改成配置或者服务器同步,则这里一起改一下
  final List<String> serverTags = ["s1", "s2"];
  final List<String> serverNames = ["进程1", "进程2"];

  // 服务器记录的*房间分享情况数据*
  final Map<String, IvrSocializeTeamInfo> teams =
      Map<String, IvrSocializeTeamInfo>();
  // 服务器记录的房间生成进度
  final Map<String, SharingGenerateProgress> progress =
      Map<String, SharingGenerateProgress>();

  // 注册消息
  void register() {
    serverTags.forEach((tag) {
      // 请求队伍得照片列表
      Application.connection
          .on(Protocol.TopicsSocializeTeamPhotoListResult + "/" + tag,
              (String topic, Map<String, dynamic> data) {
        this.onSocializeTeamPhotoListResult(tag, topic, data);
      });
      // 请求个人得照片列表
      Application.connection
          .on(Protocol.TopicsSocializePlayerPhotoListResult + "/" + tag,
              (String topic, Map<String, dynamic> data) {
        this.onSocializePlayerPhotoListResult(tag, topic, data);
      });
      // 属性获取
      Application.connection
          .on(Protocol.TopicsSocializeTeamInfoGetResult + "/" + tag,
              (String topic, Map<String, dynamic> data) {
        this.onSharingTeamInfo(tag, topic, data);
      });
      // 进度显示
      Application.connection
          .on(Protocol.TopicsSocializeTeamRunRecordProgressResult + "/" + tag,
              (String topic, Map<String, dynamic> data) {
        this.onGenerateProgressResult(tag, topic, data);
      });
    });
  }

  //
  // 主动请求服务器的API列表
  //
  // 创建房间(队伍)
  void createRoom(String tag) {
    Application.connection
        .sendMessage(Protocol.TopicsSocializeTeamCreate + "/" + tag, "");
  }

  void getOrCreateRoom(String tag) {
    Application.connection
        .sendMessage(Protocol.TopicsSocializeTeamGetOrCreate + "/" + tag, "");
  }

  void finishRoom(String tag) {
    Application.connection
        .sendMessage(Protocol.TopicsSocializeTeamFinish + "/" + tag, "");
  }

  // 开始录制材料(开始录制按钮的处理)
  void startGenerateRecord(String tag) {
    Application.connection
        .sendMessage(Protocol.TopicsSocializeTeamRunRecord + "/" + tag, "");
  }

  // 请求当前的申请状态
  void requestProgress(String tag) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializeTeamRunRecordProgressGet + "/" + tag, "");
  }

  // 请求队伍得照片列表
  void getTeamPhotos(String tag) {
    Application.connection
        .sendMessage(Protocol.TopicsSocializeTeamPhotoList + "/" + tag, "");
  }

  // 选定队伍照片
  void selectTeamPhoto(String tag, String img) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializeTeamPhotoSel + "/" + tag,
        json.encode(A2S_TeamPhotoSelect(cover: img)));
    if (teams.containsKey(tag)) {
      // 更新数据
      teams[tag].coverimg = img;

      // 刷新UI
      globalEvent.refreshUI(UIID.UI_Sharing);
    }
  }

  // 拍摄队伍照片
  void takeTeamPhoto(String tag, String img) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializeTeamPhotoTake + "/" + tag,
        json.encode(A2S_TeamPhotoTake(photo: img)));
    if (teams.containsKey(tag)) {
      // 更新数据
      teams[tag].images.add(img);

      // 刷新UI
      globalEvent.refreshUI(UIID.UI_Sharing);
    }
  }

  // 请求个人得照片列表
  void getPlayerPhotos(String tag, int index) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializePlayerPhotoList + "/" + tag,
        json.encode(A2S_PlayerPhotos(index: index)));
  }

  // 选定个人照片
  void selectPlayerPhotos(String tag, int index, String img) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializePlayerPhotoSel + "/" + tag,
        json.encode(A2S_PlayerPhotoSelect(index: index, cover: img)));

    if (teams.containsKey(tag)) {
      if (teams[tag].players.length > index) {
        // 更新数据
        teams[tag].players[index].coverimg = img;

        // 刷新UI
        globalEvent.refreshUI(UIID.UI_Sharing);
      }
    }
  }

  // 拍摄个人照片
  void takePlayerPhoto(String tag, int index, String img) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializePlayerPhotoTake + "/" + tag,
        json.encode(A2S_PlayerPhotoTake(index: index, photo: img)));

    if (teams.containsKey(tag)) {
      if (teams[tag].players.length > index) {
        // 更新数据
        teams[tag].players[index].images.add(img);

        // 刷新UI
        globalEvent.refreshUI(UIID.UI_Sharing);
      }
    }
  }

  void setPlayerNickName(String tag, int index, String name, bool enable) {
    int gamepcid = index;
    if (tag == "s1") {
      gamepcid = index + 41;
    } else if (tag == "s2") {
      gamepcid = index + 45;
    }
    if (teams.containsKey(tag)) {
      if (teams[tag].players.length > index) {
        setPlayerBaseInformation(
            tag,
            index,
            name,
            teams[tag].players[index].gender,
            teams[tag].players[index].age,
            gamepcid,
            enable);
        print("设置玩家信息:tag=$tag,index=$index,name=$name,pc=$gamepcid}");
      }
    }
  }

  void setPlayerGender(String tag, int index, int gender) {
    if (teams.containsKey(tag)) {
      if (teams[tag].players.length > index) {
        setPlayerBaseInformation(
            tag,
            index,
            teams[tag].players[index].nickname,
            gender,
            teams[tag].players[index].age,
            teams[tag].players[index].gamepcid,
            teams[tag].players[index].valid);
        print("设置玩家信息性别:tag=$tag,index=$index,gender=$gender");
      }
    }
  }

  // 设置玩家信息
  void setPlayerBaseInformation(
      String tag, int index, String name, int g, int a, int p, bool valid) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializePlayerInfoSet + "/" + tag,
        json.encode(A2S_PlayerInfoSet(
            index: index,
            nickname: name,
            gender: g,
            age: a,
            pc: p,
            valid: valid)));

    if (teams.containsKey(tag)) {
      if (teams[tag].players.length > index) {
        // 更新数据
        teams[tag].players[index].nickname = name;
        teams[tag].players[index].gender = g;
        teams[tag].players[index].age = a;
        teams[tag].players[index].gamepcid = p;
        teams[tag].players[index].valid = valid;

        // 刷新UI
        globalEvent.refreshUI(UIID.UI_Sharing);
      }
    }
  }

  // 属性获取
  void setTeamBaseInformation(String tag, String name) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializeTeamInfoSet + "/" + tag,
        json.encode(A2S_TeamInfoSet(nickname: name)));

    if (teams.containsKey(tag)) {
      // 更新数据
      teams[tag].nickname = name;

      // 刷新UI
      globalEvent.refreshUI(UIID.UI_Sharing);
    }
  }

  void getTeamInfo(String tag) {
    Application.connection
        .sendMessage(Protocol.TopicsSocializeTeamInfoGet + "/" + tag, "");
  }

  // 选择游戏
  void selectGame(String tag, String n) {
    Application.connection.sendMessage(
        Protocol.TopicsSocializeTeamGameSelect + "/" + tag,
        json.encode(A2S_GameSelect(game: n)));

    // 更新数据
    teams[tag].selectedgame = n;

    // 刷新UI
    globalEvent.refreshUI(UIID.UI_Sharing);
  }

  //
  // 消息回调处理
  //
  // 队伍的照片列表
  void onSocializeTeamPhotoListResult(
      String tag, String topic, Map<String, dynamic> list) {
    // TODO:似乎不需要了.
  }
  // 个人的照片列表
  void onSocializePlayerPhotoListResult(
      String tag, String topic, Map<String, dynamic> list) {
    // TODO:似乎不需要了.
  }
  // 视频生成的进度信息
  void onGenerateProgressResult(
      String tag, String topic, Map<String, dynamic> list) {
    S2A_RunGenerateProgress w = S2A_RunGenerateProgress.fromJson(list);
    SharingGenerateProgress p = SharingGenerateProgress();
    p.PlayerFinishCount = w.PlayerFinishCount;
    p.PlayerTotalCount = w.PlayerTotalCount;
    p.PrereqFinishCount = w.PrereqFinishCount;
    p.PrereqTotalCount = w.PrereqTotalCount;

    progress[tag] = p;

    // 刷新UI
    globalEvent.refreshUI(UIID.UI_Sharing);
  }

  // 房间的队伍数据
  void onSharingTeamInfo(String tag, String topic, Map<String, dynamic> list) {
    IvrSocializeTeamInfo w = IvrSocializeTeamInfo.fromJson(list);

    // 更新数据
    teams[tag] = w;

    // 刷新UI
    globalEvent.refreshUI(UIID.UI_Sharing);
  }

  //
  // 本地使用的API
  //
  IvrSocializeTeamInfo getTeamWithTag(String tag) {
    if (teams.containsKey(tag)) {
      return teams[tag];
    }
    return null;
  }

  SharingGenerateProgress getProgressWithTag(String tag){
    if (progress.containsKey(tag)){
      return progress[tag];
    }
    return null;
  }

  IvrSocializeTeamInfo getTeamWithIndex(int index) {
    String tag = getServerTag(index);
    if (teams.containsKey(tag)) {
      return teams[tag];
    }
    return null;
  }

  IvrSocializePlayerInfo getPlayerWithTag(String tag, int i) {
    var t = getTeamWithTag(tag);
    if (t == null) {
      return null;
    }
    if (i >= t.players.length) {
      return null;
    }
    return t.players[i];
  }

  IvrSocializePlayerInfo getPlayerWithIndex(int index, int i) {
    var t = getTeamWithIndex(index);
    if (t == null) {
      return null;
    }
    if (i >= t.players.length) {
      return null;
    }
    return t.players[i];
  }

  // 波次(服务器)数目
  int getServerCount() {
    return serverTags.length;
  }

  String getServerTag(int index) {
    if (index < 0 || index >= getServerCount()) {
      return "NONE";
    }
    return serverTags[index];
  }

  String getServerName(int index) {
    if (index < 0 || index >= getServerCount()) {
      return "NONE";
    }
    return serverNames[index];
  }
}
