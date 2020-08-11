import 'dart:convert';

import 'core/provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * Auth :   liubo
 * Date :   2019/9/23 14:24
 * Comment: 配置信息
 */

const String defaultIp = '192.168.50.76';

// todo https://book.flutterchina.club/chapter11/json_model.html
class SettingDataJson {
  String ydlip = '';
  bool useYdl = true;
  bool autoCloseSteamVR = true;
  bool newVersion = true;
  String ip = defaultIp;
  String recordAddress = '';

  SettingDataJson({this.ip, this.ydlip, this.recordAddress, this.useYdl, this.autoCloseSteamVR});

  //SettingDataJson();

  SettingDataJson.fromJson(Map<String, dynamic> json)
      : ip = json['ip'] ?? defaultSettingDataJson.ip,
        newVersion = json['newVersion'] ?? defaultSettingDataJson.newVersion,
        ydlip = json['ydlip'],
        recordAddress = json['recordAddress'],
        autoCloseSteamVR = json['autoCloseSteamVR'],
        useYdl = json['useydl'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ip': ip,
        'ydlip': ydlip,
        'recordAddress': recordAddress,
        'useydl': useYdl,
        'autoCloseSteamVR': autoCloseSteamVR,
        'newVersion': newVersion,
      };
}

var defaultSettingDataJson = SettingDataJson();

class SettingData extends IvrData {
  static const String _key = 'setting_data';
  SettingDataJson data = SettingDataJson();

  bool changeIp(String ip) {
    if (data.ip != ip) {
      data.ip = ip;

      save();
      dirty();

      return true;
    }

    return false;
  }

  void changeUiNewVersion(bool newVersion) {
    if (data.newVersion != newVersion) {
      data.newVersion = newVersion;
      save();
      dirty();
    }
  }

  bool changeRecordAddress(String add) {
    if (data.recordAddress != add) {
      data.recordAddress = add;
      save();
      dirty();
      return true;
    }
    return false;
  }

  bool changeYdlIp(String ip) {
    if (data.ydlip != ip) {
      data.ydlip = ip;
      save();
      dirty();
      return true;
    }
    return false;
  }

  bool changeUseYdl(bool u) {
    if (data.useYdl != u) {
      data.useYdl = u;
      save();
      dirty();
      return true;
    }
    return false;
  }

  bool changeCloseSteamVR(bool b) {
    if (data.autoCloseSteamVR != b) {
      data.autoCloseSteamVR = b;
      save();
      dirty();
      return true;
    }
    return false;
  }

  void load() async {
    var _prefs = await SharedPreferences.getInstance();
    var str = _prefs.getString(_key);

    data = new SettingDataJson.fromJson(json.decode(str ?? "{}"));

    if (data.ip == null || data.ip.length == 0) {
      data.ip = defaultIp;
    }
    if (data.ydlip == null || data.ydlip.length == 0) {
      data.ydlip = defaultIp;
    }
    if (data.recordAddress == null || data.recordAddress.length == 0) {
      data.recordAddress = "http://192.168.50.76";
    }
    if (data.useYdl == null) {
      data.useYdl = true;
    }
    if (data.autoCloseSteamVR == null) {
      data.autoCloseSteamVR = true;
    }

    print('读取的配置信息：$data');

    dirty();
  }

  void save() async {
    var _prefs = await SharedPreferences.getInstance();
    print('保存配置信息：$data');
    _prefs.setString(_key, json.encode(data));
  }

  void load2() async {
    try {
      File file = await _getLocalFile('$_key.json');
      // 读取点击次数（以字符串）
      String str = await file.readAsString();
      if (str != null && str.length > 0) {
        data = new SettingDataJson.fromJson(json.decode(str));
      }
    } on FileSystemException {
      print('读文件失败');
    }
  }

  void save2() async {
    try {
      File file = await _getLocalFile('$_key.json');
      // 读取点击次数（以字符串）
      await file.writeAsString(json.encode(data));
    } on FileSystemException {
      print('写文件失败');
    }
  }

  Future<File> _getLocalFile(String filename) async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/jsons/$filename').create(recursive: true);
  }
}
