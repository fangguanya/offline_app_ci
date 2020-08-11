// 段落2：展示游戏状态，并且有一个“ReadyGo”按钮
/*
* 游戏状态的格式为：
*     背包电脑1       [强制关闭]
*        进程是否在，是否蓝房子，是否矫正了身高，是否矫正了定位
* */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:operator_controller/dialogs/block_dialog.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device_state.dart';

import '../style.dart';

class SectionReadyGo extends IvrStatefulWidget<OneGameData> {
  SectionReadyGo([OneGameData d]) : super(data: d);

  @override
  SectionReadyGoState createState() => new SectionReadyGoState();
}

class SectionReadyGoState extends IvrWidgetState<SectionReadyGo> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    if (data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    if (data.timeout) {
      return Text('网络超时了，请检查中控服务器', textAlign: TextAlign.center,);
    }

    if (data.gameFlag == Constants.GameFlagReadyGo) {
    } else {
      //return Text('游戏状态:${data.gameFlag}');
      return Container();
    }

    var widgets = List<Widget>();
    widgets.add(Text(
      '游戏准备阶段',
      textScaleFactor: 1.5,
    ));

    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('可以启动的背包电脑数量：'),
        Text('${data.seatCount}', style: IvrStyle.getWarningTextStyle(true), textScaleFactor: 1.2,)
      ],));

    widgets.add(Section2OneGameServerState(true, data.gameServer));

    data.clients.forEach((k, v) {
      widgets.add(Section2OnePC(v));
    });

    var rows = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          textColor: Colors.white,
          color: Colors.green,
          child: Text("开始游戏"),
          onPressed: () {
                  OneDialog.showDialogOkCancel(context, '确定要[开始游戏]吗？', null,
                      () {
                    print('开始游戏！');
                    Application.connection.readyGame(data.gameServer.id);
                    showBlockDialog(1, context);
                  });
                },
        ),
        SizedBox(width:20),
        FlatButton(
          textColor: Colors.white,
          color: Colors.orange,
          child: Text('关闭所有游戏'),
          onPressed: () {
            OneDialog.showDialogOkCancel(context, '确定要[关闭所有游戏]吗？', null, () {
              print('关闭所有！');
              Application.connection.closeGame(data.gameServer.id);
              showBlockDialog(1, context);
            });
          },
        )
      ],
    );

    widgets.add(Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: rows,
    ));

    return Container(
      child: Column(
        children: widgets,
      ),
    );
  }
}

class Section2OnePC extends IvrStatefulWidget<GameClientStateData> {
  Section2OnePC([GameClientStateData d]) : super(data: d);

  @override
  Section2OnePCState createState() => new Section2OnePCState();
}

class Section2OnePCState extends IvrWidgetState<Section2OnePC> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    if (data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    var btnText = !data.isOnline ? '启动游戏' : '强制关闭';
    var shouldHas = Application.dataCenter.shouldHasClient(data.id);
    var shouldText = shouldHas ? '取消此设备' : '添加设备';
    var seatStatus = Application.dataCenter.isSeatRead(data.id);

    var root = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '背包电脑:${data.id}',
                  textScaleFactor: 1.2,
                ),
                FlatButton(
                  child: !shouldHas ? null : Text(btnText),
                  textColor: Colors.white,
                  color: Colors.orange,
                  onPressed: !shouldHas
                      ? null
                      : () {
                          OneDialog.showDialogOkCancel(
                              context, '确定要[$btnText:${data.id}]吗？', null, () {
                            print('$btnText ${data.id}');
                            if (data.isOnline) {
                              Application.connection
                                  .closeGameClient(data.id);
                            } else {
                              Application.connection.openGameClient(data.id);
                            }
                          });
                        },
                ),
                FlatButton(
                  child: Text(shouldText),
                  textColor: Colors.white,
                  color: Colors.orange,
                  onPressed: () {

                    if(!shouldHas) {
                      var d = Application.dataCenter.getGameDataByClientId(data.id);
                      if(d == null || d.desiredDeviceList.length - 1 + 1 > d.seatCount) {
                        OneDialog.showDialogOk(context, '背包电脑数量过多');
                        return;
                      }
                    }

                    OneDialog.showDialogOkCancel(
                        context, '确定要[$btnText:${data.id}]吗？', null, () {
                      print('$btnText ${data.id}');
                      if(shouldHas) {
                        Application.connection.eraseClient(data.id);
                      } else {
                        Application.connection.addClient(data.id);
                      }
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
            child: Text('换为男性'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              Application.connection.changeAvatar(data.serverId, data.id, Constants.AvatarBoy);
            }),
                Spacer(),
        FlatButton(
            child: Text('换为女性'),
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              Application.connection.changeAvatar(data.serverId, data.id, Constants.AvatarGirl);
            }),
              ],
            )
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
              Text("进程是否存在[${data.hasProcess}]", style: IvrStyle.getWarningTextStyle(data.hasProcess),),
              Text("是否连接到了服务器[${data.online}]", style: IvrStyle.getWarningTextStyle(data.online)),
              Text("是否到设置了playerid[${data.hasPlayerId}]", style: IvrStyle.getWarningTextStyle(data.hasPlayerId)),
              Text("是否到达蓝房子[${data.blue}]", style: IvrStyle.getWarningTextStyle(data.blue)),
              Text("是否矫正了身高[${data.height}]", style: IvrStyle.getWarningTextStyle(data.height)),
              //Text('是否矫正了定位[${data.locator}]', style: IvrStyle.getWarningTextStyle(data.locator)),
              Text('座椅是否准备好了[$seatStatus]', style: IvrStyle.getWarningTextStyle(seatStatus)),
              Text('追踪器的电量[${data.trackerBattery.toStringAsFixed(2)}]'),
              Text('形象[' + Constants.getAvatarDesc(data.avatar) + "]"),

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

class Section2OneGameServerState
    extends IvrStatefulWidget<GameServerStateData> {
  final bool hasBtn;

  Section2OneGameServerState(this.hasBtn, [GameServerStateData t])
      : super(data: t);

  @override
  Section2OneGameServerStateState createState() =>
      Section2OneGameServerStateState();
}

class Section2OneGameServerStateState
    extends IvrWidgetState<Section2OneGameServerState> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    if (data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    var btnText = !data.hasProcess ? '启动游戏' : '强制关闭';

    var root = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "游戏服务器：${data.id}",
                textScaleFactor: 1.2,
              ),
//              FlatButton(
//                child: !widget.hasBtn ? null : Text(btnText),
//                textColor: Colors.white,
//                color: Colors.orange,
//                onPressed: !widget.hasBtn
//                    ? null
//                    : () {
//                        OneDialog.showDialogOkCancel(
//                            context, '确定要[$btnText:${data.id}]吗？', null, () {
//                          print('$btnText ${data.id}');
//                          if (data.isOnline) {
//                            Application.connection.closeDeviceProcess(data.id);
//                          } else {
//                            Application.connection.openDeviceProcess(data.id);
//                          }
//                        });
//                      },
//              ),
            ],
          ),
          false ? Container() : Align(
            //alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Spacer(flex: 10,),
                FlatButton(
            child: Text('简单'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              Application.connection.modifyDifficulty(data.id, 2);
            }),
                Spacer(),
        FlatButton(
            child: Text('中等'),
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              Application.connection.modifyDifficulty(data.id, 1);
            }),
                Spacer(),
        FlatButton(
            child: Text('困难'),
            textColor: Colors.white,
            color: Colors.orange,
            onPressed: () {
              Application.connection.modifyDifficulty(data.id, 0);
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
              Text("是否连接到了中控服务器[${data.online}]", style: IvrStyle.getWarningTextStyle(data.online),),
              Text("游戏进度：[${data.step}]"),
              Text("游戏难度：[${data.diff}]"),
            ],
          )
        ],
      ),
    );

    return root;
  }
}
