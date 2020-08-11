/**
 * Auth :   liubo
 * Date :   2020/5/10 17:37
 * Comment: 游戏进行中
 */
import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/adapt.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:operator_controller/panel/onegame/gameviewport_alldevices.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../style.dart';
import 'onebattle_readygo.dart';

class OneBattleGaming extends IvrStatefulWidget<OneGameData> {
  OneBattleGaming([OneGameData d]) : super(data: d);

  @override
  _OneBattleGamingState createState() => _OneBattleGamingState();
}

class _OneBattleGamingState extends IvrWidgetState<OneBattleGaming> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    if (data == null) {
      return Container();
    }

    if (data.gameFlag == Constants.GameFlagGaming) {
    } else {
      return Container();
    }

    return Container(
      child: Container(
        child: Column(
          children: <Widget>[
            OneBattleGamingPanel1(data),
            OneBattleGamingPanel2(data),
            OneBattleGamingPanel3(data),
            SizedBox(
              height: IvrPixel.px140,
            ),
          ],
        ),
      ),
    );
  }
}

// 服务器状态
class OneBattleGamingPanel1 extends IvrStatefulWidget<OneGameData> {
  OneBattleGamingPanel1([OneGameData d]) : super(data: d);

  @override
  _OneBattleGamingPanel1State createState() => _OneBattleGamingPanel1State();
}

class _OneBattleGamingPanel1State
    extends IvrWidgetState<OneBattleGamingPanel1> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    var diffDesc = Constants.GetDifficultyDesc(data.gameServer.diff);

    return Container(
      margin: EdgeInsets.all(IvrPixel.px40),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: IvrPixel.px11,
          ),
          battleState("state_function", "${data.gameServer.gameName}",
              IvrColor.c79F7AD),
          SizedBox(
            height: IvrPixel.px40,
          ),
          IvrTitle(RichText(
            text: TextSpan(
                style: IvrStyle.getFont48(),
                text: "游戏服务器：",
                children: [
                  TextSpan(
                      text: "${data.gameServer.id}",
                      style: IvrStyle.getFont48(color: IvrColor.c95F9DE)),
                ]),
          )),
          SizedBox(
            height: IvrPixel.px31,
          ),
          IvrPanel(Container(
            margin: EdgeInsets.all(IvrPixel.px40),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    deviceStateWidget1("游戏进程：", data.gameServer.online),
                    deviceStateWidget1("已连接中控服务器：", data.gameServer.hasProcess),
                  ],
                ),
                SizedBox(
                  height: IvrPixel.px40,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "游戏进度：",
                      style: IvrStyle.getFont40(color: IvrColor.c7F7F7F),
                    ),
                    Text(
                      "${data.gameServer.step}",
                      style: IvrStyle.getFont40(),
                    ),
                  ],
                ),
                SizedBox(
                  height: IvrPixel.px40,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        style: IvrStyle.getFont48(color: IvrColor.c7F7F7F),
                        text: "给本次游戏选择困难程度：",
                        children: [
                          TextSpan(
                              text: "$diffDesc",
                              style:
                                  IvrStyle.getFont48(color: IvrColor.c95F9DE)),
                        ]),
                  ),
                ),
                SizedBox(
                  height: IvrPixel.px20,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

// 背包电脑状态
class OneBattleGamingPanel2 extends IvrStatefulWidget<OneGameData> {
  OneBattleGamingPanel2([OneGameData d]) : super(data: d);

  @override
  _OneBattleGamingPanel2State createState() => _OneBattleGamingPanel2State();
}

class _OneBattleGamingPanel2State
    extends IvrWidgetState<OneBattleGamingPanel2> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    var pc = List<Widget>();
    data.clients.forEach((k, v) {
      if (data.desiredDeviceList.contains(k)) {
        pc.add(OneBattleGamingPanel2PCOnline(v));
      }
    });

    return Container(
      child: Column(
        children: pc,
      ),
    );
  }
}

// 背包电脑（在线）
class OneBattleGamingPanel2PCOnline extends StatelessWidget {
  GameClientStateData data;

  OneBattleGamingPanel2PCOnline(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          IvrPixel.px40, IvrPixel.px15, IvrPixel.px40, IvrPixel.px15),
      child: IvrPanel2(Container(
        margin: EdgeInsets.fromLTRB(
            IvrPixel.px20, IvrPixel.px10, IvrPixel.px40, IvrPixel.px40),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, IvrPixel.px20, 0),
              child: deviceAddPcWidget4("背包电脑:${data.id}", data.step, null),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(IvrPixel.px20, 0, IvrPixel.px20, 0),
              child:
                  devicePcPower(Application.dataCenter.getPcBattery(data.id)),
            ),
            Container(
              margin: EdgeInsets.all(IvrPixel.px20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: IvrPixel.px40,
                  ),
                  SizedBox(
                    height: IvrPixel.px40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      playerEnterLeaveAreaWidget(
                          data.step == Constants.AreaLeave),
                      !data.hasProcess
                          ? Container()
                          : IvrButton3("强制关闭", IvrPixel.px360, callback: () {
                              OneDialog.showDialogOkCancel(
                                  context, '确定要【强制踢出此玩家:${data.id}】吗？', null,
                                  () {
                                print('强制踢出此玩家！');
                                Application.connection
                                    .closeGameClient2(data.id, true);
                              });
                            }),
                    ],
                  ),
                ],
              ),
            )

            //IvrProgressBar(0.1, Pixel.px700),
          ],
        ),
      )),
    );
  }
}

// 背包电脑，游戏进度
Widget deviceAddPcWidget4(String text, int gameStep, VoidCallback callback) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          Image(
            image: IvrAssets.getPng("icon_pc"),
            width: IvrPixel.px108,
            height: IvrPixel.px108,
          ),
          Text(
            text,
            style: IvrStyle.getFont44(color: IvrColor.cFFFFFF),
          ),
        ],
      ),
      RichText(
        text: TextSpan(
            style: IvrStyle.getFont48(color: IvrColor.c7F7F7F),
            text: "游戏进度：",
            children: [
              TextSpan(
                text: "$gameStep",
                style: IvrStyle.getFont48(color: IvrColor.cFFFFFF),
              ),
            ]),
      ),
    ],
  );
}

class OneBattleGamingPanel3 extends IvrStatefulWidget<OneGameData> {
  OneBattleGamingPanel3([OneGameData d]) : super(data: d);

  @override
  _OneBattleGamingPanel3State createState() => _OneBattleGamingPanel3State();
}

class _OneBattleGamingPanel3State
    extends IvrWidgetState<OneBattleGamingPanel3> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: IvrPixel.px65,
          ),
          IvrButton(
            "结束游戏",
            IvrPixel.px600,
            callback: () {
              OneDialog.showDialogOkCancel(context, '确定要【关闭所有游戏】吗？', null, () {
                print('关闭所有背包电脑');
                Application.connection.closeGame(data.gameServer.id);
              });
            },
          ),
          SizedBox(
            height: IvrPixel.px40,
          ),
          Text(
            "将自动关闭所有背包电脑的游戏进程",
            style: IvrStyle.getFont36(color: IvrColor.c7F7F7F),
          ),
        ],
      ),
    );
  }
}
