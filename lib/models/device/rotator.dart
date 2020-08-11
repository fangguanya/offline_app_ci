import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';

class Rotator extends Device {
  Rotator(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.ROTATOR;
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
    if (Application.dataCenter.settingData.data.useYdl) {
      Application.hardwareYDL.sendMessage('setoriginangle');
    } else {
      Application.connection
          .sendMessage(Protocol.TopicsOperateConfigRotatorReset, "");
    }
  }

  // 关闭设备
  @override
  void turnOff(dynamic args) {
    if (Application.dataCenter.settingData.data.useYdl) {
      Application.hardwareYDL.sendMessage('setoriginangle');
    } else {
      Application.connection
          .sendMessage(Protocol.TopicsOperateConfigRotatorReset, "");
    }
  }
}
