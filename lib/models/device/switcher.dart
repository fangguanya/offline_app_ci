import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/protocol.dart';
import 'dart:convert';

class Switcher extends Device {
  int switchState = 0;

  Switcher(int i, int ydli) : super(i, ydli);
  // 设备类型
  @override
  DeviceType type() {
    return DeviceType.SWITCH;
  }

  @override
  register() {
    super.register();
  }

  @override
  unRegister() {
    super.unRegister();
  }

  @override
  void onHardwareState(String topic, Map<String, dynamic> list) {
    super.onHardwareState(topic, list);

    // 只需要处理'switch state'部分
    HardwareStateUpdate w = HardwareStateUpdate.fromJson(list);
    if (w.id == id && w.type == this.type()) {
      for (int i = 0; i < w.stats.length; ++i) {
        if (w.stats[i].state == DeviceStateType.SWITCHS) {
          switchState = w.stats[i].value;
        }
      }
    }
  }

  // 运行设备
  @override
  void turnOn(dynamic args) {
    if (args is String) {
      remoteControl(int.parse(args) ?? 0, true);
    } else if (args is int) {
      remoteControl(args, true);
    }
  }

  // 关闭设备
  @override
  void turnOff(dynamic args) {
    if (args is String) {
      remoteControl(int.parse(args) ?? 0, false);
    } else if (args is int) {
      remoteControl(args, false);
    }
  }

  // 特定端口的继电器状态
  bool isSwitchOn(int index) {
    // 服务器记录每个端口的状态,1=开启,0=关闭
    bool r = (switchState & (1 << index)) != 0;
    return r;
  }

  // 开启指定的继电器端口
  // 注意:继电器/音频震动/喷气/风扇/电动门等统一控制!
  void remoteControl(int index, bool enable) {
    if (Application.dataCenter.settingData.data.useYdl) {
      String onoff = enable ? "true" : "false";
      // 临时转一下,TODO:改成可配置!!!
      int ydlidex = index;
      if (ydlidex == 7) {
        ydlidex = 4;
      } else if (ydlidex == 9) {
        ydlidex = 5;
      } else if (ydlidex == 10) {
        ydlidex = 1;
      } else if (ydlidex == 11) {
        ydlidex = 2;
      } else if (ydlidex == 12) {
        ydlidex = 3;
      }
      Application.hardwareYDL.sendMessage('seteff:$ydlidex,$onoff');
    } else {
      // index : 继电器上的端口ID(一般=0...15)
      int s = enable ? 1 : 0;
      Application.connection.sendMessage(Protocol.TopicsFan,
          json.encode(FanInfo(id: id, index: index, state: s)));
    }
  }
}
