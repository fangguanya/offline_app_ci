import 'package:flutter/material.dart';
import 'package:operator_controller/logic/connection.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:fluro/fluro.dart';
import 'package:operator_controller/logic/routers.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/onegame/section_all_device.dart';
import 'package:operator_controller/panel/onegame/section_gaming.dart';
import 'dart:convert';

import 'package:operator_controller/panel/onegame/section_selectpc.dart';
import 'package:operator_controller/panel/onegame/section_readygo.dart';

import 'gameviewport.dart';

class OneGamePanel extends IvrStatefulWidget {

  final String id;
  OneGamePanel({this.id}) : super(evtId:UIID.UI_AllDevices);

  @override
  OneGameState createState() => OneGameState();
}

class OneGameState extends IvrWidgetState<OneGamePanel> {

  MyGame mygame;

  @override
  Widget build(BuildContext context) {

    var game = Application.dataCenter.gameDatas[widget.id];

    if(mygame == null) {
      mygame = MyGame();
    }
    mygame.setGameData(game);

    if(game == null || game.timeout) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            (game?.gameFlag == Constants.GameFlagGaming || game?.gameFlag == Constants.GameFlagReadyGo) ? mygame.widget : Container(),
            Text('网络超时了，请检查中控服务器', textScaleFactor: 1.5, textAlign: TextAlign.center,),
          ],
        ),
      );
    }

    var root = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          (game?.gameFlag == Constants.GameFlagGaming || game?.gameFlag == Constants.GameFlagReadyGo)  ? mygame.widget : Container(),
          SectionAllDevice(),
          Divider(height:10.0,indent:0.0,color: Colors.red,),
          SectionSelectPc(game),
          SectionReadyGo(game),
          SectionGaming(game),
        ],
      ),
    );

    return root;
  }
}

