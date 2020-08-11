


import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/panel/onegame/section_readygo.dart';

import '../style.dart';

class SectionGaming extends IvrStatefulWidget<OneGameData> {

  SectionGaming([OneGameData d]) : super(data:d);

  @override
  SectionGamingState createState() => new SectionGamingState();
}

class SectionGamingState extends IvrWidgetState<SectionGaming> {
  @override
  Widget build(BuildContext context) {

    var data = widget.data;
    if(data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    if(data.gameFlag == Constants.GameFlagGaming) {

    } else {
      return Text('游戏状态:${data.gameFlag}');
    }

    if(data.timeout) {
      return Text('网络超时了，请检查中控服务器');
    }

    var widgets = List<Widget>();

    widgets.add(Text('游戏过程中', textScaleFactor: 1.5,));

    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('可以启动的背包电脑数量：'),
        Text('${data.seatCount}', style: IvrStyle.getWarningTextStyle(true), textScaleFactor: 1.2,)
      ],));

    widgets.add(Section2OneGameServerState(false, data.gameServer));

    data.clients.forEach((k, v) {
      widgets.add(SectionGamingOnePc(v));
    });

    widgets.add(FlatButton(
      textColor: Colors.white,
      color: Colors.green,
      child: Text("游戏已经结束，关闭所有背包电脑"),
      onPressed: (){
        OneDialog.showDialogOkCancel(context, '确定要[关闭所有游戏]吗？', null, (){
          print('关闭所有背包电脑');
          Application.connection.closeGame(data.gameServer.id);
        });
      },
    ));

    var root = Container(
        child: Column(
          children: widgets,
        )
    );

    return root;
  }
}

class SectionGamingOnePc extends IvrStatefulWidget<GameClientStateData> {

  SectionGamingOnePc([GameClientStateData d]) : super(data:d);

  @override
  SectionGamingOnePcState createState() => new SectionGamingOnePcState();
}

class SectionGamingOnePcState extends IvrWidgetState<SectionGamingOnePc> {
  @override
  Widget build(BuildContext context) {

    var data = widget.data;
    if(data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    var seatStatus = Application.dataCenter.isSeatRead(data.id);
    var shouldHas = Application.dataCenter.shouldHasClient(data.id);

    var root = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          Center(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('背包电脑:${data.id}', textScaleFactor: 1.2,),
                FlatButton(
                  child: !data.isOnline ? null : Text("强制踢出此玩家"),
                  textColor: Colors.white,
                  color: Colors.orange,
                  onPressed: !data.isOnline ? null : (){
                    OneDialog.showDialogOkCancel(context, '确定要[强制踢出此玩家:${data.id}]吗？', null, (){
                      print('强制踢出此玩家！');
                    Application.connection.closeGameClient2(data.id, true);
                    });
                  },
                ),
              ],
            ),
          ),
          !shouldHas ? Container() : Align(
            //alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Spacer(flex: 10,),
                  FlatButton(
                      child: Text('开始内部校准'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () {
                        Application.connection.adjustPosition(data.id, true);
                      }),
                  Spacer(),
                  FlatButton(
                      child: Text('关闭内部校准'),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () {
                        Application.connection.adjustPosition(data.id, false);
                      }),
                ],
              )
          ),

          Wrap(
            spacing: 8.0, // 主轴(水平)方向间距
            runSpacing: 4.0, // 纵轴（垂直）方向间距
            alignment: WrapAlignment.start,
            children: <Widget>[
              Text("进程是否在？[${data.hasProcess}]", style: IvrStyle.getWarningTextStyle(data.hasProcess),),
              Text("是否连接到了服务器[${data.online}]", style: IvrStyle.getWarningTextStyle(data.online),),
              Text('座椅是否准备好了[$seatStatus]', style: IvrStyle.getWarningTextStyle(seatStatus)),
              Text("游戏进度：[${data.step}]"),
              Text("是否到达了离场区域[${data.inLeaveArea}]"),
              Text("追踪器的电量[${data.trackerBattery}]"),

              Text('定位步骤[${data.count.toStringAsFixed(0)}]'),
              Text('定位进度百分比[${data.percent.toStringAsFixed(1)}]'),
              Text("是否正在校准[${data.adjusting}]", style: IvrStyle.getWarningTextStyle(!data.adjusting)),
              Text("是否丢失定位[${data.losingTracking}]", style: IvrStyle.getWarningTextStyle(!data.losingTracking)),
            ],
          )
        ],
      ),
    );

    return root;
  }
}
