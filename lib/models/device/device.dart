import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/protocol.dart';

// 设备对象
abstract class Device {
  int id;
  int ydlid;
  DeviceStateValue state;
  // 上一次更新状态的时间戳
  int lastStatTimestamp;

  Device(int i, int ydli) {
    id = i;
    ydlid = ydli;
    lastStatTimestamp = 0;
    state = DeviceStateValue.OFF;
  }

  // 设备类型
  DeviceType type();
  // 设备影动力映射
  int idydl(){
    return ydlid;
  }
  // 设备状态
  DeviceStateValue status() {
//    var now = DateTime.now().millisecondsSinceEpoch;
//    if ((now - lastStatTimestamp) > 4 * 1000) {
//      // 局域网应该没有多少个设备,超过2s则认为关机了.
//      return DeviceStateValue.OFF;
//    }
    return state;
  }

  // 运行设备
  void turnOn(dynamic args);
  // 关闭设备
  void turnOff(dynamic args);

  // 协议处理的注册等
  void register() {
    Application.connection.on(Protocol.TopicsOperateHardwareState, this.onHardwareState);
  }

  void unRegister() {
    Application.connection.off(Protocol.TopicsOperateHardwareState, this.onHardwareState);
  }

  void onHardwareState(String topic, Map<String, dynamic> list) {
    // 可被继承,这里只实现了'on/off'相关的
    HardwareStateUpdate w = HardwareStateUpdate.fromJson(list);
    if (w.id == id && w.type == this.type()) {
      for (int i = 0; i < w.stats.length; ++i) {
        if (w.stats[i].state == DeviceStateType.ONOFF) {
          state = DeviceStateValue(w.stats[i].value);
          lastStatTimestamp = DateTime.now().millisecondsSinceEpoch;
        }
      }
      globalEvent.emit(DeviceDispatcher.DEVICE_CHANGED);
      globalEvent.refreshUI(UIID.UI_Hardware);
      globalEvent.refreshUI(UIID.UI_AllDevices);
      globalEvent.refreshUI(UIID.UI_BattleMap);
    }
  }
  // 影动力的状态同步
  void onYdlHardwareState(bool onoff, bool running){
    if (onoff){
      if (running){
        state = DeviceStateValue.RUN;
      }else{
        state = DeviceStateValue.IDLE;
      }
    }else{
      state = DeviceStateValue.OFF;
    }
    lastStatTimestamp = DateTime.now().millisecondsSinceEpoch;
    globalEvent.emit(DeviceDispatcher.DEVICE_CHANGED);
    globalEvent.refreshUI(UIID.UI_Hardware);
    globalEvent.refreshUI(UIID.UI_AllDevices);
    globalEvent.refreshUI(UIID.UI_BattleMap);
  }
}
