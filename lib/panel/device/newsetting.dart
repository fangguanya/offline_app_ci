import 'dart:ui';

/**
 * Auth :   liubo
 * Date :   2020/5/11 18:00
 * Comment: 新的设置页面
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

import '../setting.dart';
import '../style.dart';

class NewSetting extends IvrStatefulWidget<IvrData> {
  NewSetting([IvrData d]) : super(data: d, evtId: UIID.UI_Hardware);

  @override
  NewSettingState createState() => NewSettingState();
}

class NewSettingState extends IvrWidgetState<NewSetting> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  bool open = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(
          vsync: this,
            duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        open = true;
      } else if (status == AnimationStatus.dismissed) {
        //Application.newsetting = false;
        //globalEvent.refreshUI(UIID.UI_Hardware);
        //Navigator.of(context).pop();
      }
    });

    if (!open) {
      //animationController.forward(); //启动动画
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if(animationController != null) {
      animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    double _width = mediaQuery.size.width;

    return Transform.translate(
      offset: Offset(0 * (1 - animation.value) * _width, 0),
      child: Scaffold(
        backgroundColor: IvrColor.c000000,
        appBar: AppBar(
            automaticallyImplyLeading:false,
          title: Stack(
            children: <Widget>[
              Center(
                child: Text("设置&调试"),
              ),
              GestureDetector(
                onTap: () {
                  //OneDialog.showDialogOk(context, '上传错误:!');
                  Navigator.of(context).pop();
                  animationController.reverse();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image(
                    image: IvrAssets.getPng("btn_return"),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SettingPanel(Application.dataCenter.settingData),
      ),
    );
  }
}
