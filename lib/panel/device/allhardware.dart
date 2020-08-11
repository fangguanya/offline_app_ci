/**
 * Auth :   liubo
 * Date :   2020/5/11 16:29
 * Comment: 所有的硬件设备
 */

import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/adapt.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/monitor.dart';
import 'package:operator_controller/models/device/switcher.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/battle/onebattle_readygo.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:operator_controller/panel/onegame/gameviewport_alldevices.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../style.dart';
import 'newsetting.dart';

class AllHardware extends IvrStatefulWidget<IvrData> {
  AllHardware([IvrData d]) : super(data: d, evtId: UIID.UI_Hardware);

  @override
  AllHardwareState createState() => AllHardwareState();
}

class AllHardwareState extends IvrWidgetState<AllHardware> {
  @override
  Widget build(BuildContext context) {
    var list = new List<Widget>();

    var centerRel;
    var centerDevice;
    Application.dataCenter.hardwareRelations.forEach((rel) {
      Device d = Application.dataCenter.getHardwareByRelation(rel);

      if (rel.type == DeviceType.HSERVER) {
        centerRel = rel;
        centerDevice = d;
        return;
      }

      list.add(OneHardware(list.length, rel, d));
    });

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: IvrColor.c000000,
          appBar: AppBar(
            title: Stack(
              children: <Widget>[
                Center(
                  child: Text("场地硬件检测"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>NewSetting()));
                    //Application.newsetting = true;
                    //setState(() {});
                    //globalEvent.refreshUI(UIID.UI_Hardware);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image(
                      image: IvrAssets.getPng("btn_set"),
                      width: IvrPixel.px124,
                      height: IvrPixel.px124,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      IvrPixel.px40,
                      IvrPixel.px40 + IvrPixel.px180,
                      IvrPixel.px40,
                      IvrPixel.px40),
                  child: Column(
                    children: <Widget>[
                      IvrPanel(
                        Container(
                          child: Column(
                            children: list,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: IvrPixel.px272,
                      ),
                    ],
                  ),
                ),
              ),
              true
                  ? Container()
                  : Container(
                      //margin: EdgeInsets.fromLTRB(IvrPixel.px40,IvrPixel.px40,IvrPixel.px40,IvrPixel.px40),
                      decoration: BoxDecoration(
                        color: Color(0xC0000000),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IvrRotator(Image(
                              image: IvrAssets.getPng("loading"),
                              width: IvrPixel.px142,
                              height: IvrPixel.px142,
                            )),
                            SizedBox(
                              height: IvrPixel.px40,
                            ),
                            Text(
                              "正在自检中",
                              style: IvrStyle.getFont52(),
                            ),
                          ],
                        ),
                      ),
                    ),
              IvrHardwareCenter(centerRel, centerDevice),
            ],
          ),
        ),
        Application.newsetting ? NewSetting() : Container(),
      ],
    );
  }
}

// 中控服务器
class IvrHardwareCenter extends IvrStatefulWidget<IvrData> {
  Device device;
  WorkerRelation rel;

  IvrHardwareCenter(this.rel, this.device, [IvrData d]) : super(data: d);

  @override
  IvrHardwareCenterState createState() => IvrHardwareCenterState();
}

class IvrHardwareCenterState extends IvrWidgetState<IvrHardwareCenter> {
  @override
  Widget build(BuildContext context) {
    if (widget.rel == null) {
      return Container();
    }

    return Container(
      height: IvrPixel.px180,
      decoration: BoxDecoration(color: IvrColor.c1C1C1D),
      child: Container(
        margin: EdgeInsets.fromLTRB(IvrPixel.px55, 0, IvrPixel.px55, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IvrTitle(RichText(
              text: TextSpan(
                  style: IvrStyle.getFont48(),
                  text: "游戏服务器：",
                  children: [
                    TextSpan(
                        text: getHardwareDesc(widget.rel, widget.device),
                        style: IvrStyle.getFont48(color: IvrColor.c95F9DE)),
                  ]),
            )),
            IvrButton("一键自检", IvrPixel.px343)
          ],
        ),
      ),
    );
  }
}

// 所有硬件
class OneHardware extends IvrStatefulWidget<IvrData> {
  int idx;
  Device device;
  WorkerRelation rel;

  OneHardware(this.idx, this.rel, this.device, [IvrData d]) : super(data: d);

  @override
  OneHardwareState createState() => OneHardwareState();
}

class OneHardwareState extends IvrWidgetState<OneHardware> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.idx == 0
            ? Container()
            : IvrDivider(
                margin:
                    EdgeInsets.fromLTRB(IvrPixel.px211, IvrPixel.px10, 0, 0),
              ),
        Container(
          height: IvrPixel.px211,
          margin:
              EdgeInsets.fromLTRB(IvrPixel.px62, IvrPixel.px2, 0, IvrPixel.px2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(
                    image: IvrAssets.getPng(getIcon()),
                    width: IvrPixel.px108,
                    height: IvrPixel.px108,
                  ),
                  SizedBox(
                    width: IvrPixel.px36,
                  ),
                  Container(
                    //margin: EdgeInsets.fromLTRB(0, IvrPixel.px10, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${widget.rel.name}",
                            style: IvrStyle.getFont44(
                                color: isOnline()
                                    ? IvrColor.cFFFFFF
                                    : IvrColor.cFF7D7D)),
                        SizedBox(
                          height: IvrPixel.px6,
                        ),
                        getDeviceDescWidget2(isOnline()),
                      ],
                    ),
                  ),
                ],
              ),
              !isDoor()
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: IvrPixel.px150,
                          child: Text(
                            getDesc(),
                            style: IvrStyle.getFont36(color: IvrColor.c7F7F7F),
                          ),
                        ),
                        IvrButton4(
                          isRunning(),
                          callback: () {
                            print('操纵设备[${widget.rel.name}], 是否运行:' +
                                (isRunning() ? "1" : "0"));
                            if (isRunning()) {
                              if (widget.device != null) {
                                widget.device.turnOff(widget.rel.param);
                              }
                            } else {
                              if (widget.device != null) {
                                widget.device.turnOn(widget.rel.param);
                              }
                            }
                            // 点击
                          },
                        ),
                        SizedBox(
                          width: IvrPixel.px65,
                        )
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        IvrButton(
                          "复位",
                          IvrPixel.px280,
                          callback: () {
                            print('复位');
                            widget.device.turnOn(widget.rel.param);
                          },
                        ),
                        SizedBox(
                          width: IvrPixel.px65,
                        )
                      ],
                    ),
            ],
          ),
        )
      ],
    );
  }

  bool isOnline() {
    return gIsOnline(widget.device);
  }

  bool isRunning() {
    return gIsRunning(widget.device, widget.rel);
  }

  bool isDoor() {
    return widget.rel.type == DeviceType.ROTATOR;
  }

  String getIcon() {
    return getHarewareIcon(isOnline(), widget.rel, widget.device);
  }

  String getDesc() {
    return isRunning() ? "运行中" : "未运行";
  }
}

bool gIsOnline(Device device) {
  if (device == null) {
    return false;
  }
  if (device.status() == DeviceStateValue.OFF) {
    return false;
  }

  return true;
}

bool gIsRunning(Device device, WorkerRelation rel) {
  if (device == null) {
    return false;
  }

  if (device.status() == DeviceStateValue.RUN) {
    return true;
  }

  if (device.status() == DeviceStateValue.IDLE) {
    if (device is Switcher) {
      int idx = int.parse(rel.param) ?? 0;
      if ((device as Switcher).isSwitchOn(idx)) {
        return true;
      }
    }
  }

  return false;
}

String getHarewareIcon(bool b, WorkerRelation rel, Device d) {
  if (b) {
    if (rel.type == DeviceType.SWITCH) {
      return "icon_equipment_server1";
    }
    if (rel.type == DeviceType.ELEVATOR) {
      return "icon_equipment_elevator1";
    }
    if (rel.type == DeviceType.AUDIO) {
      return "icon_equipment_sound1";
    }
    if (rel.type == DeviceType.ROTATOR) {
      return "icon_equipment_door1";
    }
    if (rel.type == DeviceType.ROTATOR) {
      return "icon_equipment_server1";
    }

    return "icon_equipment_server1";
  }

  if (rel.type == DeviceType.SWITCH) {
    return "icon_equipment_server1";
  }
  if (rel.type == DeviceType.ELEVATOR) {
    return "icon_equipment_elevator_fault1";
  }
  if (rel.type == DeviceType.AUDIO) {
    return "icon_equipment_sound_fault1";
  }
  if (rel.type == DeviceType.ROTATOR) {
    return "icon_equipment_door_fault1";
  }
  if (rel.type == DeviceType.ROTATOR) {
    return "icon_equipment_server1";
  }

  return "icon_equipment_server_fault1";
}

String getHarewareIconSmall(WorkerRelation rel, Device d) {
  if (rel.type == DeviceType.SWITCH) {
    return "icon_equipment_server_fault";
  }
  if (rel.type == DeviceType.ELEVATOR) {
    return "icon_equipment_elevator_fault";
  }
  if (rel.type == DeviceType.AUDIO) {
    return "icon_equipment_sound_fault";
  }
  if (rel.type == DeviceType.ROTATOR) {
    return "icon_equipment_door_fault";
  }
  if (rel.type == DeviceType.ROTATOR) {
    return "icon_equipment_server1";
  }

  return "icon_equipment_server_fault";
}

String getHardwareDesc(WorkerRelation rel, Device device) {
  if (device == null) {
    return "关机";
  }
  var s = device.status();
  if (s == DeviceStateValue.IDLE) {
    if (device is Switcher) {
      int idx = int.parse(rel.param) ?? 0;
      if ((device as Switcher).isSwitchOn(idx)) {
        return "运行中";
      }
    }
    return "已开机";
  }
  if (s == DeviceStateValue.CONN) {
    return "连接外设中";
  }
  if (s == DeviceStateValue.OFF) {
    return "关机";
  }
  if (s == DeviceStateValue.RUN) {
    return "运行中";
  }
  return "未知";
}

Widget getDeviceDescWidget2(bool b) {
  return Row(
    children: <Widget>[
      Image(
        image: IvrAssets.getPng(b ? "icon_online" : "icon_offline"),
        width: IvrPixel.px36,
        height: IvrPixel.px36,
      ),
      SizedBox(
        width: IvrPixel.px10,
      ),
      Text(
        b ? "在线" : "离线",
        style: IvrStyle.getFont40(color: IvrColor.c7F7F7F),
      ),
    ],
  );
}
