/**
 * Auth :   liubo
 * Date :   2020/5/11 14:43
 * Comment: 所有背包电脑的状态
 */

import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/adapt.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/monitor.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/battle/onebattle_readygo.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:operator_controller/panel/onegame/gameviewport_alldevices.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../style.dart';

class AllPc extends IvrStatefulWidget<IvrData> {
  AllPc([IvrData d]) : super(evtId: UIID.UI_Hardware);

  @override
  AllPcState createState() => AllPcState();
}

class AllPcState extends IvrWidgetState<AllPc> {
  @override
  Widget build(BuildContext context) {
    var list = new List<Widget>();

    Application.dataCenter.pcRelations.forEach((rel) {
      if (rel.type == DeviceType.MONITOR) {
        Monitor mon = Application.dataCenter.getMonitor(rel.id);
        list.add(OnePcState(mon, rel));
      }
    });

    return Scaffold(
      backgroundColor: IvrColor.c000000,
      appBar: AppBar(
        title: Center(
          child: Text("玩家设备状态"),
        ),
      ),
      body: GridView.count(
        //primary: false,
        padding: EdgeInsets.all(IvrPixel.px50),
        crossAxisSpacing: IvrPixel.px29,
        mainAxisSpacing: IvrPixel.px30,
        crossAxisCount: 2,
        children: list,
        childAspectRatio: (IvrPixel.px508 / IvrPixel.px600),
      ),
    );
  }
}

class OnePcState extends IvrStatefulWidget<IvrData> {
  final Monitor pc;
  final WorkerRelation rel;

  OnePcState(this.pc, this.rel, [IvrData d]) : super(data: d);

  @override
  OnePcStateState createState() => OnePcStateState();
}

class OnePcStateState extends IvrWidgetState<OnePcState> {
  @override
  Widget build(BuildContext context) {
    if (widget.rel == null) {
      return Container(
        child: Text("无信息"),
      );
    }

    // 离线
    if (widget.pc == null) {
      // || widget.pc.status() == DeviceStateValue.OFF) {

      return SizedBox(
        //constraints: BoxConstraints(minWidth:IvrPixel.px508, minHeight: IvrPixel.px600),
        width: IvrPixel.px508,
        height: IvrPixel.px600,
        child: IvrPanel(
          SizedBox(
              width: IvrPixel.px508,
              height: IvrPixel.px600,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin:
                        EdgeInsets.fromLTRB(IvrPixel.px19, IvrPixel.px19, 0, IvrPixel.px15),
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: IvrAssets.getPng("icon_pc"),
                              width: IvrPixel.px108,
                              height: IvrPixel.px108,
                            ),
                            Text(
                              "${widget.rel.name}",
                              style: IvrStyle.getFont44(color: IvrColor.c7F7F7F),
                            ),
                          ],
                        )),
                    Container(
                      //offset: Offset(-IvrPixel.px20, 0),
                      child: SizedOverflowBox(
                        alignment: Alignment.center,
                        size: Size(IvrPixel.px502, IvrPixel.px53),
                        //maxWidth: IvrPixel.px452,
                        //maxHeight: IvrPixel.px53,
                        child: Container(
                          height: IvrPixel.px53,
                          width: IvrPixel.px502,
                          //color: Colors.red,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              //stops: [0.0,0.5,1.0],
                                tileMode: TileMode.clamp,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
                                colors: [
                                  Color(0xFF000000),
                                  Color(0x00000000)
                                ]), // 渐变色
                          ),
                          child: Container(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(IvrPixel.px26, 0, 0, 0),
                                child: Text(
                                  "已关机",
                                  style: IvrStyle.getFont30(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),

        ),
      );
    }

    return SizedBox(
      width: IvrPixel.px508,
      height: IvrPixel.px600,

      child: IvrPanel2(
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[

                  Container(
                    margin:
                    EdgeInsets.fromLTRB(IvrPixel.px19, IvrPixel.px25, 0, 0),
                    child: SizedBox(
                      child: Align(
                        alignment: Alignment.center,
                        child:  Row(
                          children: <Widget>[
                            Image(
                              image: IvrAssets.getPng("icon_pc"),
                              width: IvrPixel.px108,
                              height: IvrPixel.px108,
                            ),
                            Text(
                              "${widget.rel.name}",
                              style: IvrStyle.getFont44(color: IvrColor.cFFFFFF),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: IvrPixel.px15,
                  ),
                  Container(
                    height: IvrPixel.px53,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
                          colors: [Color(0xFF000000), Color(0x00000000)]), // 渐变色
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(IvrPixel.px26, 0, IvrPixel.px29, 0),
                      child: devicePcPower2(getBattery(), IvrPixel.px268),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(IvrPixel.px41, IvrPixel.px51, 0, IvrPixel.px76),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: IvrPixel.px68,
                      child:
                      // ip:
                      Row(
                        children: <Widget>[
                          Text(
                            "${widget.pc.ip}",
                            style: IvrStyle.getFont40(color: IvrColor.c7F7F7F),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: IvrPixel.px68,
                      child:getDeviceDescWidget("进程状态", getRunning()),
                    ),

                    SizedBox(
                      height: IvrPixel.px68,
                      child:
                      getDeviceDescWidget("矫正状态", getCalibrationRunning()),
                    ),
                    SizedBox(
                      height: IvrPixel.px68,
                      child:
                      getDeviceDescWidget("前一次结果", getCalibrationResult()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getRunning() {
    if (widget.pc == null) {
      return "关机";
    }
    return widget.pc.isRunning("fixer.exe") ? "运行中" : "未启动";
  }

  String getCalibrationRunning() {
    if (widget.pc == null) {
      return "关机";
    }
    return widget.pc.isCalibrationRunning() ? "正在校准" : "空闲";
  }

  String getCalibrationResult() {
    if (widget.pc == null) {
      return "关机";
    }
    return widget.pc.prevCalibrationResult;
  }

  double getBattery() {
    if (widget.pc == null) {
      return 0;
    }
    var s = widget.pc.status();
    if (s == DeviceStateValue.OFF) {
      return 0;
    }
    return widget.pc.getBatterPercentage() / 100;
  }
}

Widget getDeviceDescWidget(String name, String status) {
  return Row(
    children: <Widget>[
      Text(
        "$name：",
        style: IvrStyle.getFont40(color: IvrColor.c7F7F7F),
      ),
      Text(
        "$status",
        style: IvrStyle.getFont40(),
      ),
    ],
  );
}
