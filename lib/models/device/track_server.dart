import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/protocol.dart';

// 定位服务器
class TrackServer extends Device {
  // 定位追踪设备状态
  List<TrackerDeviceState> devices = new List<TrackerDeviceState>();

  TrackServer(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.TSERVER;
  }

  @override
  register() {
    super.register();
    Application.connection.on(Protocol.TopicsOperateHardwareState, this.onHardwareState);
  }

  @override
  unRegister() {
    super.unRegister();
    Application.connection.off(Protocol.TopicsOperateHardwareState, this.onHardwareState);
  }

  // 收到定位追踪设备状态
  void onTrackerState(String topic, Map<String, dynamic> list) {
    TrackerDeviceStateUpdate w = TrackerDeviceStateUpdate.fromJson(list);
    // 是否需要额外的处理呢?
    devices = w.devices;
  }

  // 运行设备
  @override
  void turnOn(dynamic args) {}
  // 关闭设备
  @override
  void turnOff(dynamic args) {}

  int countOfStations() {
    int result = 0;
    devices.forEach((f) {
      if (f.type == HtcDeviceType.BASE) {
        result++;
      }
    });
    return result;
  }

  int countOfTrackers() {
    int result = 0;
    devices.forEach((f) {
      if (f.type == HtcDeviceType.TRACKER) {
        result++;
      }
    });
    return result;
  }

  bool hasOffStation() {
    return devices.any((f) {
      if (f.type == HtcDeviceType.BASE && f.on == 0) {
        return true;
      }
      return false;
    });
  }

  bool hasOffTracker() {
    return devices.any((f) {
      if (f.type == HtcDeviceType.TRACKER && f.on == 0) {
        return true;
      }
      return false;
    });
  }

  List<TrackerDeviceState> getAllDevices() {
    return devices;
  }
}
