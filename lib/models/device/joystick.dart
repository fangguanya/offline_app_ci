import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/protocol.dart';
import 'dart:convert';

class Joystick extends Device {
  Joystick(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.JOYSTICK;
  }

  @override
  register() {
    super.register();
  }

  @override
  unRegister() {
    super.unRegister();
  }

  // 运行设备
  @override
  void turnOn(dynamic args) {
    remoteControl(0, 1, 1);
  }

  // 关闭设备
  @override
  void turnOff(dynamic args) {
    remoteControl(0, 1, 0);
  }

  // 开启指定的继电器端口
  // 注意:继电器/音频震动/喷气/风扇/电动门等统一控制!
  void remoteControl(int index, int channel, int state) {
    if (!Application.dataCenter.settingData.data.useYdl){
      // 虽然提供了多channel支持,但是测试只需要1个
      Application.connection.sendMessage(
          Protocol.TopicsVibrateAudio, json.encode(VibrateInfo(id: id, index: index, channel: channel, state: state)));
    }
  }
}
