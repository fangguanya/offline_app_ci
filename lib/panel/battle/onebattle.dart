/**
 * Auth :   liubo
 * Date :   2020/5/6 9:24
 * Comment: 游戏进程1
 */

import 'package:flutter/material.dart';
import 'package:operator_controller/logic/adapt.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/panel/onegame/gameviewport_alldevices.dart';

import '../style.dart';
import 'onebattle_gaming.dart';
import 'onebattle_readygo.dart';
import 'onebattle_selectpc.dart';

class OneBattle extends IvrStatefulWidget<IvrData> {
  final String id;

  OneBattle([this.id]) : super(evtId: UIID.UI_AllDevices);

  @override
  OneBattleState createState() => OneBattleState();
}

class OneBattleState extends IvrWidgetState<OneBattle> {

  int oldFlag = 0;
  ScrollController ctrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ctrl = ScrollController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(ctrl != null) {
      ctrl.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var game = Application.dataCenter.gameDatas[widget.id];

    if(game == null) {
      return Container();
    }

    if(game.gameFlag != oldFlag) {

      var skip = false;

      if(oldFlag == Constants.GameFlagCloseGame && game.gameFlag == Constants.GameFlagNoGame) {
        skip = true;
      }

      oldFlag = game.gameFlag;



      if(!skip && ctrl.hasClients) {
        ctrl.animateTo(
          0,
          duration: new Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }


    return SingleChildScrollView(
      controller: ctrl,
      child: Column(
        children: <Widget>[
          OneBattleSelectPC(game),
          OneBattleReadyGo(game),
          OneBattleGaming(game),
        ],
      ),
    );
  }
}
