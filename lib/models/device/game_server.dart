import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';

// TODO:需要游戏部分提供支持
class GameServer extends Device {
  GameServer(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.GSERVER;
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
  void turnOn(dynamic args) {}
  // 关闭设备
  @override
  void turnOff(dynamic args) {}
}
