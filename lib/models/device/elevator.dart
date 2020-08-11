import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/protocol.dart';
import 'dart:convert';

class Elevator extends Device {
  Elevator(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.ELEVATOR;
  }

  @override
  register() {
    super.register();
    Application.hardwareYDL.on("btn", onYdlButtonClick);
  }

  @override
  unRegister() {
    super.unRegister();
    Application.hardwareYDL.off("btn", onYdlButtonClick);
  }

  // 运行设备
  @override
  void turnOn(dynamic args) {
    remoteControl(true);
  }

  // 关闭设备
  @override
  void turnOff(dynamic args) {
    remoteControl(false);
  }

  // 按钮按下事件
  void onYdlButtonClick(String msg) {
    var clicks = msg.split(",");
    print('ydl-button : $clicks');
  }

  // 开启指定的继电器端口
  // 注意:继电器/音频震动/喷气/风扇/电动门等统一控制!
  void remoteControl(bool enable) {
    if (Application.dataCenter.settingData.data.useYdl) {
      if (enable) {
        Application.hardwareYDL.sendMessage("setshake:-50,50,500");
      } else {
        Application.hardwareYDL.sendMessage("closeshake:");
      }
    } else {
      int s = enable ? 1 : 0;
      Application.connection.sendMessage(Protocol.TopicsElevatorVibrate,
          json.encode(ElevatorInfo(id: id, level: 2, state: s)));
      if (!enable) {
        Application.connection.sendMessage(Protocol.TopicsElevatorVibrate,
            json.encode(ElevatorInfo(id: id, level: 1, state: s)));
      }
    }
  }
}
