// 颜色常量
import 'package:flutter/material.dart';

class AppColors {
  static const int mainColor = 0xffFB6894;
  static const int lightGray = 0xff71768C;
  static const int themeColor = 0xff21272E;
  static const int fontColor = 0xff000000;
  static const int fontColorGray = 0xfff9DA3B4;
  static const int themeColorGray = 0xff2A2C33;
  static const int fontColorYellow = 0xffFFCE44;
  static const int borderColor = 0xff45485B;
}

// 数值常量
class Constants {
  static const double bottomIconWidth = 24.0;
  static const double bottomIconHeight = 24.0;
  static const double appBarIconSize = 16.0;
  // 页面左右边距
  static const double pageMargin = 24.0;

  static const int IdLevelArea = 27;

  static const int GameFlagNoGame = 0;
  static const int GameFlagReadyGo = 1;
  static const int GameFlagGaming = 2;
  static const int GameFlagCloseGame = 3;

  static const int AppendClientOpAdd = 1;
  static const int AppendClientOpDelete = -1;

  // 5秒内收不到数据，就算超时。
  static const int MaxTimeoutMillisecond = 3 * 1000;

  static const int RunProcess = 1;
  static const int KillProcess = 2;
  static const int FlagForceKill = 3;

  static const int AreaLeave = 28;

  static const int AvatarBoy = 1;
  static const int AvatarGirl = 2;
  static String getAvatarDesc(int avatar) {
    if (avatar == AvatarGirl) {
      return "女性";
    }
    return "男性";
  }

  // 获取性别参数
  static int getAvatarGender(int avatar){
//    Gender       int      `json:"gender"`                // 0:不清楚,1:男,2:女
    if (avatar == AvatarBoy){
      return 1;
    }
    if (avatar == AvatarGirl){
      return 2;
    }
    return 0;
  }

  // 困难度
  static const int GameDifficultyEasy = 2;
  static const int GameDifficultyMid = 1;
  static const int GameDifficultyHard = 0;

  static String GetDifficultyDesc(int id) {
    if (id == GameDifficultyEasy) {
      return "简单";
    } else if (id == GameDifficultyMid) {
      return "中等";
    } else if (id == GameDifficultyHard) {
      return "困难";
    }
    return "未知";
  }
}

class UIID {
  static const String UI_BattleMap = 'battlemap';
  static const String UI_AllDevices = 'alldevices';
  static const String UI_Settings = 'settings';
  static const String UI_Hardware = 'hardware';
  static const String UI_Sharing = 'sharing'; // 当视频分享相关的数据发生改变,notify到UI部分
}
