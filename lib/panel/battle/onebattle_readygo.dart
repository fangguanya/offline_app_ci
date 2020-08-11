/**
 * Auth :   liubo
 * Date :   2020/5/9 14:24
 * Comment: 游戏准备
 */

import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/block_dialog.dart';
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

class OneBattleReadyGo extends IvrStatefulWidget<OneGameData> {
  OneBattleReadyGo([OneGameData d]) : super(data: d);

  @override
  OneBattleReadyGoState createState() => OneBattleReadyGoState();
}

class OneBattleReadyGoState extends IvrWidgetState<OneBattleReadyGo> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    if (data == null) {
      return Container();
    }

    if (data.gameFlag == Constants.GameFlagReadyGo) {
    } else {
      return Container();
    }

    return Container(
      child: Container(
        //margin: EdgeInsets.all(Pixel.px40),
        child: Column(
          children: <Widget>[
            OneBattleReadyGoStatePanel1(data),
            OneBattleReadyGoStatePanel2(data),
            OneBattleReadyGoStatePanel3(data),
            SizedBox(
              height: IvrPixel.px140,
            ),
          ],
        ),
      ),
    );
  }
}

class OneBattleReadyGoStatePanel1 extends IvrStatefulWidget<OneGameData> {
  OneBattleReadyGoStatePanel1([OneGameData d]) : super(data: d);

  @override
  OneBattleReadyGoStatePanel1State createState() =>
      OneBattleReadyGoStatePanel1State();
}

class OneBattleReadyGoStatePanel1State
    extends IvrWidgetState<OneBattleReadyGoStatePanel1> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    return Container(
      margin: EdgeInsets.all(IvrPixel.px40),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: IvrPixel.px11,
          ),
          battleState(
              "state_ready", "${data.gameServer.gameName}", IvrColor.cFFE86E),
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
            height: IvrPixel.px38,
          ),
          IvrPanel(Container(
            margin: EdgeInsets.all(IvrPixel.px40),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    deviceStateWidget1("游戏进程：", data.gameServer.hasProcess),
                    deviceStateWidget1("已连接游戏服务器：", data.gameServer.online),
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
                  child: Text(
                    "给本次游戏选择困难程度：",
                    style: IvrStyle.getFont40(color: IvrColor.c7F7F7F),
                  ),
                ),
                SizedBox(
                  height: IvrPixel.px20,
                ),
                Row(
                  children: <Widget>[
                    IvrButton(
                      "简单",
                      IvrPixel.px308,
                      disable:
                          data.gameServer.diff != Constants.GameDifficultyEasy,
                      callback: () {
                        Application.connection.modifyDifficulty(
                            data.gameServer.id, Constants.GameDifficultyEasy);
                      },
                    ),
                    SizedBox(
                      width: IvrPixel.px20,
                    ),
                    IvrButton("中等", IvrPixel.px308,
                        disable: data.gameServer.diff !=
                            Constants.GameDifficultyMid, callback: () {
                      Application.connection.modifyDifficulty(
                          data.gameServer.id, Constants.GameDifficultyMid);
                    }),
                    SizedBox(
                      width: IvrPixel.px20,
                    ),
                    IvrButton("困难", IvrPixel.px308,
                        disable: data.gameServer.diff !=
                            Constants.GameDifficultyHard, callback: () {
                      Application.connection.modifyDifficulty(
                          data.gameServer.id, Constants.GameDifficultyHard);
                    }),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class OneBattleReadyGoStatePanel3 extends IvrStatefulWidget<OneGameData> {
  OneBattleReadyGoStatePanel3([OneGameData d]) : super(data: d);

  @override
  OneBattleReadyGoStatePanel3State createState() =>
      OneBattleReadyGoStatePanel3State();
}

class OneBattleReadyGoStatePanel3State
    extends IvrWidgetState<OneBattleReadyGoStatePanel3> {
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
            "开始游戏",
            IvrPixel.px600,
            callback: () {
              OneDialog.showDialogOkCancel(context, '确定要【开始游戏】吗？', null, () {
                print('开始游戏！');
                Application.connection.readyGame(data.gameServer.id);
                showBlockDialog(1, context);
              });
            },
          ),
          SizedBox(
            height: IvrPixel.px40,
          ),
          IvrButton2(
            "结束本次游戏",
            callback: () {
              var team = Application.dataCenter.sharing
                  .getTeamWithTag(widget.data.gameServer.id);
              if (team != null &&
                  (team.videourl15 == null || team.videourl15.length <= 0)) {
//                OneDialog.showDialogOk(context, '视频还未生成完毕!');
                OneDialog.showDialogOkCancel(
                    context, '视频还未生成完毕！确定要【关闭所有游戏】吗？', null, () {
                  print('关闭所有！');
                  Application.connection.closeGame(data.gameServer.id);
                  showBlockDialog(1, context);
                });
              } else {
                OneDialog.showDialogOkCancel(context, '确定要【关闭所有游戏】吗？', null,
                    () {
                  print('关闭所有！');
                  Application.connection.closeGame(data.gameServer.id);
                  showBlockDialog(1, context);
                });
              }
            },
          ),
          Text(
            getProgressDesc(),
            textAlign: TextAlign.center,
            style: IvrStyle.getFont48(color: getColor()),
          ),
        ],
      ),
    );
  }

  Color getColor(){
    var tag = widget.data.gameServer
        .id; //Application.dataCenter.sharing.getServerTag(widget.selectedIndex);
    var progress = Application.dataCenter.sharing.getProgressWithTag(tag);
    var team = Application.dataCenter.sharing.getTeamWithTag(tag);
    if (progress == null || team == null) {
      return IvrColor.cFF8181;
    }
    if (team.videourl15 != null && team.videourl15.length > 0) {
      return IvrColor.c79F7AD;
    }
    return IvrColor.cFF8181;
  }

  String getProgressDesc() {
    var tag = widget.data.gameServer.id;
    var progress = Application.dataCenter.sharing.getProgressWithTag(tag);
    var team = Application.dataCenter.sharing.getTeamWithTag(tag);
    if (progress == null || team == null) {
      return "INVALID";
    }
    if (team.videourl15 != null && team.videourl15.length > 0) {
      return "已完成拼接分享视频!";
    }
    if (progress.PlayerTotalCount == 0 || progress.PlayerFinishCount == 0) {
      return "分享视频拼接未开始";
    } else {
      var p = 0.0;
      p = progress.PlayerFinishCount / progress.PlayerTotalCount;
      var p1 = (p * 99).floor();
      return "视频拼接进度:$p1%";
    }
  }
}

// 背包电脑列表
class OneBattleReadyGoStatePanel2 extends IvrStatefulWidget<OneGameData> {
  OneBattleReadyGoStatePanel2([OneGameData d]) : super(data: d);

  @override
  OneBattleReadyGoStatePanel2State createState() =>
      OneBattleReadyGoStatePanel2State();
}

class OneBattleReadyGoStatePanel2State
    extends IvrWidgetState<OneBattleReadyGoStatePanel2> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    var pc = List<Widget>();
    data.clients.forEach((k, v) {
      if (!data.desiredDeviceList.contains(k)) {
        pc.add(OneBattleReadyGoStatePanel2PCOffline(v));
      } else {
        pc.add(OneBattleReadyGoStatePanel2PCOnline(v));
      }
    });

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(
              IvrPixel.px40, IvrPixel.px10, IvrPixel.px40, IvrPixel.px31),
          child: IvrTitle(RichText(
            text:
                TextSpan(style: IvrStyle.getFont48(), text: "可以启动共", children: [
              TextSpan(
                  text: " ${data.seatCount}台 ",
                  style: IvrStyle.getFont48(color: IvrColor.c95F9DE)),
              TextSpan(text: "背包电脑"),
            ]),
          )),
        ),
        Column(
          children: pc,
        ),
      ],
    );
  }
}

// 背包电脑（离线）
class OneBattleReadyGoStatePanel2PCOffline extends StatelessWidget {
  GameClientStateData data;

  OneBattleReadyGoStatePanel2PCOffline(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          IvrPixel.px40, IvrPixel.px15, IvrPixel.px40, IvrPixel.px15),
      child: IvrPanel(Container(
        margin: EdgeInsets.fromLTRB(
            IvrPixel.px20, IvrPixel.px0, IvrPixel.px40, IvrPixel.px40),
        child: Column(
          children: <Widget>[
            deviceAddPcWidget2("背包电脑:${data.id}", true, () {
              if (true) {
                var d = Application.dataCenter.getGameDataByClientId(data.id);
                if (d == null ||
                    d.desiredDeviceList.length - 1 + 1 > d.seatCount) {
                  OneDialog.showDialogOk(context, '背包电脑数量过多');
                  return;
                }
              }

              OneDialog.showDialogOkCancel(
                  context, '确定要【添加:${data.id}】吗？', null, () {
                print('添加 ${data.id}');
                Application.connection.addClient(data.id);
              });
            }),
            Container(
              margin: EdgeInsets.fromLTRB(IvrPixel.px20, 0, 0, 0),
              child:
                  devicePcPower(Application.dataCenter.getPcBattery(data.id)),
            )

            //IvrProgressBar(0.1, Pixel.px700),
          ],
        ),
      )),
    );
  }
}

// 背包电脑（在线）
class OneBattleReadyGoStatePanel2PCOnline extends StatelessWidget {
  GameClientStateData data;

  OneBattleReadyGoStatePanel2PCOnline(this.data);

  @override
  Widget build(BuildContext context) {
    var btnText = "启动游戏";
    if (data.hasProcess) {
      btnText = "关闭游戏";
    }

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
              child: deviceAddPcWidget2("${data.id}", false, () {
                OneDialog.showDialogOkCancel(
                    context, '确定要【取消:${data.id}】吗？', null, () {
                  print('取消 ${data.id}');
                  Application.connection.eraseClient(data.id);
                });
              }),
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
                  Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IvrRadioMan(data.avatar == Constants.AvatarBoy, () {
                            Application.connection.changeAvatar(
                                data.serverId, data.id, Constants.AvatarBoy);
                          }),
                          SizedBox(
                            width: IvrPixel.px20,
                          ),
                          IvrRadioWoman(data.avatar == Constants.AvatarGirl,
                              () {
                            Application.connection.changeAvatar(
                                data.serverId, data.id, Constants.AvatarGirl);
                          }),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          data.hasProcess
                              ? Container()
                              : deviceStateWidget3("游戏进程不存在"),
                          SizedBox(
                            height: IvrPixel.px20,
                          ),
                          data.online
                              ? Container()
                              : deviceStateWidget3("服务器连接失败"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: IvrPixel.px40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      playerEnterLeaveAreaWidget(data.blue && data.hasPlayerId),
                      IvrButton(
                        "$btnText",
                        IvrPixel.px360,
                        callback: () {
                          OneDialog.showDialogOkCancel(
                              context, '确定要【$btnText:${data.id}】吗？', null, () {
                            print('$btnText ${data.id}');
                            if (data.isOnline) {
                              Application.connection.closeGameClient(data.id);
                            } else {
                              Application.connection.openGameClient(data.id);
                            }
                          });
                        },
                      ),
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

// 状态标题
Widget battleState(String png, String text, Color color) {
  return Stack(
    children: <Widget>[
      Image(image: IvrAssets.getPng(png)),
      Container(
        margin: EdgeInsets.fromLTRB(IvrPixel.px94, IvrPixel.px105, 0, 0),
        child: Text(
          text,
          style: IvrStyle.getFont44(color: color),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, IvrPixel.px17, 0),
        alignment: Alignment.centerRight,
        child: Image(
          image: IvrAssets.getPng("game_icon11"),
          width: IvrPixel.px194,
          height: IvrPixel.px194,
        ),
      )
    ],
  );
}

// 游戏进程
Widget deviceStateWidget1(String text, bool online) {
  return Row(
    children: <Widget>[
      Text(text, style: IvrStyle.getFont40(color: IvrColor.c7F7F7F)),
      //SizedBox(width:Pixel.px10),
      Image(
        image: IvrAssets.getPng(online ? "icon_right" : "icon_error"),
        width: IvrPixel.px40,
        height: IvrPixel.px40,
      )
    ],
  );
}

// 玩家已到达指定区域
Widget playerEnterLeaveAreaWidget(bool reached) {
  return deviceStateWidget2((reached ? "已经" : "未") + "到达指定区域", reached);
}

Widget deviceStateWidget2(String text, bool online) {
  return Row(
    children: <Widget>[
      Image(
        image: IvrAssets.getPng(online ? "icon_right" : "icon_error"),
        width: IvrPixel.px40,
        height: IvrPixel.px40,
      ),
      SizedBox(
        width: IvrPixel.px10,
      ),
      Text(text, style: IvrStyle.getFont36(color: IvrColor.cFFFFFF)),
      //SizedBox(width:Pixel.px10),
    ],
  );
}

// 游戏进程是否存在
Widget deviceStateWidget3(String text) {
  return Row(
    children: <Widget>[
      Image(
        image: IvrAssets.getPng("icon_warning"),
        width: IvrPixel.px40,
        height: IvrPixel.px40,
      ),
      SizedBox(
        width: IvrPixel.px36,
      ),
      Text(text, style: IvrStyle.getFont36(color: IvrColor.cFF7D7D)),
      //SizedBox(width:Pixel.px10),
    ],
  );
}

// 电量
Widget devicePcPower(double power) {
  return devicePcPower2(power, IvrPixel.px767);
}

Widget devicePcPower2(double power, double width) {
  var color = IvrColor.c95F9DE;
  if (power < 0.3) {
    color = IvrColor.cFF7D7D;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          Text("电量：", style: IvrStyle.getFont30(color: IvrColor.cB5B5B5)),
          Text("" + (power * 100).toStringAsFixed(0) + "%",
              style: IvrStyle.getFont30(color: color)),
        ],
      ),
      IvrProgressBar(power, width),
    ],
  );
}

// 背包电脑+添加设备
Widget deviceAddPcWidget2(String text, bool add, VoidCallback callback) {
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
      deviceAddPcWidget1(add, callback),
    ],
  );
}

// 添加设备，取消设备
Widget deviceAddPcWidget1(bool add, VoidCallback callback) {
  return GestureDetector(
    child: Row(
      children: <Widget>[
        Image(
          image: IvrAssets.getPng(add ? "icon_plus" : "icon_reduce"),
          height: IvrPixel.px36,
          width: IvrPixel.px36,
        ),
        SizedBox(
          width: IvrPixel.px10,
        ),
        Text(
          add ? "添加该设备" : "取消该设备",
          style: IvrStyle.getFont36(color: IvrColor.cB5B5B5),
        ),
      ],
    ),
    onTap: callback,
  );
}
