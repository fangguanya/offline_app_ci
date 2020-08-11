import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';

// 硬件中控服务器
class CenterServer extends Device {
  CenterServer(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.HSERVER;
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
