import 'package:operator_controller/models/core/vnum.dart';

// 设备类型
@VnumDefinition
class DeviceType extends Vnum<int> {
  const DeviceType.define(int fromValue) : super.define(fromValue);
  factory DeviceType(int value) => Vnum.fromValue(value, DeviceType);
  dynamic toJson() => this.value;
  factory DeviceType.fromJson(dynamic json) => DeviceType(json);

  // 继电器
  static const DeviceType SWITCH = const DeviceType.define(1);
  // 电梯
  static const DeviceType ELEVATOR = const DeviceType.define(2);
  // 加速度计
  static const DeviceType ROTATOR = const DeviceType.define(3);
  // 摇杆设备
  static const DeviceType JOYSTICK = const DeviceType.define(4);
  // 音频震动
  static const DeviceType AUDIO = const DeviceType.define(5);
  // 游戏服务器
  static const DeviceType GSERVER = const DeviceType.define(11);
  // 硬件中控服务器
  static const DeviceType HSERVER = const DeviceType.define(12);
  // 硬件定位服务器
  static const DeviceType TSERVER = const DeviceType.define(14);
  // PC电脑(所有设备都会执行)
  static const DeviceType MONITOR = const DeviceType.define(100);
}

// 设备的状态同步
@VnumDefinition
class DeviceStateType extends Vnum<int> {
  const DeviceStateType.define(int fromValue) : super.define(fromValue);
  factory DeviceStateType(int value) => Vnum.fromValue(value, DeviceStateType);
  dynamic toJson() => this.value;
  factory DeviceStateType.fromJson(dynamic json) => DeviceStateType(json);

  // 设备的运行态
  static const DeviceStateType ONOFF = const DeviceStateType.define(1);
  // 设备电量数据
  static const DeviceStateType BATTERY = const DeviceStateType.define(2);
  // 继电器的端口状态
  static const DeviceStateType SWITCHS = const DeviceStateType.define(3);
}

// 设备的状态同步
@VnumDefinition
class DeviceStateValue extends Vnum<int> {
  const DeviceStateValue.define(int fromValue) : super.define(fromValue);
  factory DeviceStateValue(int value) => Vnum.fromValue(value, DeviceStateValue);
  dynamic toJson() => this.value;
  factory DeviceStateValue.fromJson(dynamic json) => DeviceStateValue(json);

  // 完成开机了(如果是硬件,则为硬件正常启动,idle)
  static const DeviceStateValue IDLE = const DeviceStateValue.define(1);
  // 关机失联
  static const DeviceStateValue OFF = const DeviceStateValue.define(2);
  // 工作中
  static const DeviceStateValue RUN = const DeviceStateValue.define(3);
  // 外设链接当中
  static const DeviceStateValue CONN = const DeviceStateValue.define(4);

  String getDesc() {
    if (this == DeviceStateValue.IDLE) {
      return "已开机";
    }
    if (this == DeviceStateValue.CONN) {
      return "连接外设中";
    }
    if (this == DeviceStateValue.OFF) {
      return "关机";
    }
    if (this == DeviceStateValue.RUN) {
      return "运行中";
    }
    return "未知";
  }
}

// HTC设备的类型 : 1)头显,2)手柄,3)追踪器,4)基站
@VnumDefinition
class HtcDeviceType extends Vnum<int> {
  const HtcDeviceType.define(int fromValue) : super.define(fromValue);
  factory HtcDeviceType(int value) => Vnum.fromValue(value, HtcDeviceType);
  dynamic toJson() => this.value;
  factory HtcDeviceType.fromJson(dynamic json) => HtcDeviceType(json);

  static const HtcDeviceType HMD = const HtcDeviceType.define(1);
  static const HtcDeviceType CONTROLLER = const HtcDeviceType.define(2);
  static const HtcDeviceType TRACKER = const HtcDeviceType.define(3);
  static const HtcDeviceType BASE = const HtcDeviceType.define(4);
}

// 进程运行控制
@VnumDefinition
class ExecutionType extends Vnum<int> {
  const ExecutionType.define(int fromValue) : super.define(fromValue);
  factory ExecutionType(int value) => Vnum.fromValue(value, ExecutionType);
  dynamic toJson() => this.value;
  factory ExecutionType.fromJson(dynamic json) => ExecutionType(json);

  // 直接启动
  static const ExecutionType START = const ExecutionType.define(1);
  // 关闭
  static const ExecutionType STOP = const ExecutionType.define(2);
  // 重启
  static const ExecutionType RESTART = const ExecutionType.define(3);
}

// 事件描述
class DeviceDispatcher {
  static const String MONITOR_CHANGED = "MONITOR_CHANGED";
  static const String MONITOR_DETAIL_CHANGED = "MONITOR_DETAIL_CHANGED";
  static const String DEVICE_CHANGED = "DEVICE_CHANGED";
  static const String RELATIONS_CHANGED = "RELATIONS_CHANGED";
  static const String STATS_CHANGED = "STATS_CHANGED";
  static const String DEVICE_STATE_CHANGED = "DEVICE_STATE_CHANGED";
  static const String REFLECT_STATE_CHANGED = "REFLECT_STATE_CHANGED";
}
