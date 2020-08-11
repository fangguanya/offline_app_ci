import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/config_data.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/settings/detail_tracker.dart';
import 'package:operator_controller/panel/settings/section_tracker.dart';
import 'package:operator_controller/panel/style.dart';
import 'package:operator_controller/dialogs/toast.dart';

import 'battle/widget.dart';
import 'hardware/section_hardware.dart';
import 'onegame/gameviewport.dart';
import 'onegame/gameviewport_test.dart';

/**
 * Auth :   liubo
 * Date :   2019/9/23 11:44
 * Comment: 设置界面
 */

class SettingPanel extends IvrStatefulWidget<SettingData> {
  SettingPanel([SettingData d]) : super(data: d, evtId: UIID.UI_Settings);

  @override
  SettingPanelState createState() => SettingPanelState();
}

class SettingPanelState extends IvrWidgetState<SettingPanel> {
  String _ip = "0.0.0.0";
  String _ydlIp = "0.0.0.0";
  String _recordAddress = "http://127.0.0.1";
  Timer t;
  TextEditingController ctrl;
  TextEditingController ydlCtrl;
  TextEditingController recordCtrl;
  bool useYdlCtrlValue;
  bool autoCloseSteamVR;
  var bShowGameviewport = false;

  @override
  void initState() {
    super.initState();

    loopSetTimer();
  }

  void loopSetTimer() {
    t?.cancel();

    t = Timer(Duration(seconds: 1), () {
      if (this.mounted) {
        setState(() {});
      }
      loopSetTimer();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    if (data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    _ip = data.data.ip;
    _ydlIp = data.data.ydlip;
    _recordAddress=data.data.recordAddress;
    if (useYdlCtrlValue == null) {
      useYdlCtrlValue = data.data.useYdl;
    }
    if (autoCloseSteamVR == null){
      autoCloseSteamVR = data.data.autoCloseSteamVR;
    }
    var c = Application.connection;
    var connectting = c != null && c.isConnected();
    var desc = connectting ? '已连接' : '未连接';

    if (ctrl == null) {
      ctrl = TextEditingController(text: '$_ip');
    }
    if (ydlCtrl == null) {
      ydlCtrl = TextEditingController(text: _ydlIp);
    }
    if (recordCtrl == null){
      recordCtrl = TextEditingController(text: _recordAddress);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(40, 40, 40, 20),
      child: ListView(
        children: <Widget>[
          Text(
            '设置界面',
            textScaleFactor: 2,
          ),
          TextField(
            controller: ctrl,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              icon: Icon(Icons.text_fields),
              labelText: '服务器IP',
            ),
            onChanged: (v) {},
            autofocus: false,
          ),
          Row(
            children: <Widget>[
              Text(
                '$desc:${c.broker}:${c.port}',
                style: IvrStyle.getWarningTextStyle(connectting),
              ),
            ],
          ),
          TextField(
            controller: recordCtrl,
            keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              icon: Icon(Icons.text_fields),
              labelText: '视频录制网址:',
            ),
            onChanged: (v) {},
            autofocus: false,
          ),
          // ----------------------------------UDP----------------------------------
          TextField(
            controller: ydlCtrl,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              icon: Icon(Icons.text_fields),
              labelText: '影动力IP',
            ),
            onChanged: (v) {},
            autofocus: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Text(
                  '是否为影动力',
                ),
              ),
              SizedBox(
                width: 60,
                child: Switch(
                  value: useYdlCtrlValue,
                  onChanged: (value) {
                    //重新构建页面
                    setState(() {
                      useYdlCtrlValue = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 120,
                child: RaisedButton(
                  child: Text("重启影动力"),
                  onPressed: () {
//                    OneDialog.showDialogOk(context, '上传错误:!');
                    var monitor = Application.dataCenter.getMonitor(76);
                    if (monitor != null) {
                      // TODO:配置影动力的进程
//                      monitor.runWithName("vrmonitor.exe", ExecutionType.RESTART);
                      print('自动重启影动力控制进程');
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Text(
                  '自动重启SteamVR',
                ),
              ),
              SizedBox(
                width: 60,
                child: Switch(
                  value: autoCloseSteamVR,
                  onChanged: (value) {
                    //重新构建页面
                    setState(() {
                      autoCloseSteamVR = value;
                    });
                  },
                ),
              ),
            ],
          ),
          // ----------------------------------UDP----------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("保存"),
                onPressed: () {
                  print('保存服务器IP！[$ctrl.value.text]');
                  var b = data.changeIp(ctrl.value.text);
                  if (b) {
                    Application.onIpChanged();
                  }
                  var b1 = data.changeYdlIp(ydlCtrl.value.text);
                  if (b1) {
                    Application.onYdlIpChanged();
                  }
                  var b2 = data.changeUseYdl(useYdlCtrlValue);
                  if (b2) {
                    Application.onUseYdlChanged();
                  }
                  var b3 = data.changeCloseSteamVR(autoCloseSteamVR);
                  if (b3) {
                    Application.onCloseSteamVRChanged();
                  }
                  var b4 = data.changeRecordAddress(recordCtrl.value.text);
                  if (b4){
                    Application.onRecordAddressChanged();
                  }
                },
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                child: Text("重连"),
                onPressed: () {
                  Application.connection.reconnect();
                },
              ),
            ],
          ),
          // ----------------------------------空间校定----------------------------------

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("打开白模场景"),
                onPressed: () {
                  // 对当前开启的所有电脑都执行即可(一般只需要在特定PC配置白模场景就行了)
                  var m = Application.dataCenter.getMonitors();
                  m.forEach((f) {
                    f.turnOff("spacetest.exe");
                    f.turnOn("spacetest.exe");
                  });
                },
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                child: Text("标定空间"),
                color: Colors.greenAccent,
                onPressed: () {
                  // 触发请求
                  Application.connection.sendMessage(Protocol.TopicsOperateAltGenerateSpace, "");
                },
              ),
              SizedBox(
                width: 15,
              ),
              RaisedButton(
                child: Text("关闭"),
                onPressed: () {
                  // 对当前开启的所有电脑都执行即可(一般只需要在特定PC配置白模场景就行了)
                  var m = Application.dataCenter.getMonitors();
                  m.forEach((f) {
                    f.turnOff("spacetest.exe");
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20,),
//          Row(children: <Widget>[Column(children: <Widget>[DetailTrackerWidget([], "xxxx", 2)],),]),
//          Row(children: <Widget>[Column(children: <Widget>[SectionTrackerWidget([])],),]),
//          Row(children: <Widget>[SectionTrackerWidget([]),],),
          SectionTrackerWidget([DeviceDispatcher.REFLECT_STATE_CHANGED]),
          IvrRow(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("ALIVE"),
                onPressed: () {
                  Application.dataCenter.loadDevices(false);
                },
              ),
              RaisedButton(
                child: Text("ALL"),
                onPressed: () {
                  Application.dataCenter.loadDevices(true);
                },
              ),
            ],
          ),
          SizedBox(height: 20,),
//          RaisedButton(
//            child:Text("测试"),
//            onPressed: () {
//              showMyCustomLoadingDialog(context);
//              Timer(new Duration(seconds: 1), (){
//                Navigator.of(context).pop();
//              });
//            },)
          RaisedButton(
            child: Text("测试游戏窗口"),
            onPressed: () {
              bShowGameviewport = !bShowGameviewport;
              setState(() => {});
            },
          ),
          !bShowGameviewport ? Container() : TestGameviewport(IvrData()),

          SizedBox(height: 20,),

          IvrRow(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("HTC", style: TextStyle(fontSize: 15.0, color: getStatusColor(0))),
                onPressed: () {
                  Application.dataCenter.setCalibrationStatus(0);
                },
              ),
              RaisedButton(
                child: Text("RIFTS", style: TextStyle(fontSize: 15.0, color: getStatusColor(1))),
                onPressed: () {
                  Application.dataCenter.setCalibrationStatus(1);
                },
              ),
              RaisedButton(
                child: Text("HYBRID", style: TextStyle(fontSize: 15.0, color: getStatusColor(2))),
                onPressed: () {
                  Application.dataCenter.setCalibrationStatus(2);
                },
              ),
            ],
          ),

          SizedBox(height: 20,),

          IvrRow(
            //spacing: 10,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[RaisedButton(child: Text("新版"), onPressed:(){
              data.changeUiNewVersion(true);
              globalEvent.refreshUI(UIID.UI_Settings);
            }),
            RaisedButton(child: Text("旧版"), onPressed:(){
              data.changeUiNewVersion(false);
              globalEvent.refreshUI(UIID.UI_Settings);
            }),
            ],
          )
        ],
      ),
    );
  }
}
