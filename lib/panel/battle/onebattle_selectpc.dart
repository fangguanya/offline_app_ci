import 'dart:ui';

/**
 * Auth :   liubo
 * Date :   2020/5/8 14:24
 * Comment: 选择背包电脑
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

class OneBattleSelectPC extends IvrStatefulWidget<OneGameData> {
  OneBattleSelectPC([OneGameData d]) : super(data: d);

  @override
  OneBattleSelectPCState createState() => OneBattleSelectPCState();
}

class OneBattleSelectPCState extends IvrWidgetState<OneBattleSelectPC> {
  bool canSlideupPanel = true;

  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    if (data == null) {
      return Container();
    }

    if (data.gameFlag == Constants.GameFlagNoGame ||
        data.gameFlag == Constants.GameFlagCloseGame) {
    } else {
      return Container();
    }

    return Container(
      child: Column(
        children: <Widget>[
          OneBattleSelectPCPanel1(data),
          OneBattleSelectPCPanel2(data),
        ],
      ),
    );
  }
}

class OneBattleSelectPCPanel1 extends IvrStatefulWidget<IvrData> {
  OneBattleSelectPCPanel1([IvrData d]) : super(data: d);

  @override
  OneBattleSelectPCPanel1State createState() => OneBattleSelectPCPanel1State();
}

class OneBattleSelectPCPanel1State
    extends IvrWidgetState<OneBattleSelectPCPanel1> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    //
    var px1 = IvrPixel.px1;
    var top = 80 / px1;
    var bottom = 80 / px1;
    var all = MediaQueryData.fromWindow(window).size.height / px1;

    var height = Adapt.screenH() - IvrPixel.px60 - IvrPixel.px132 - IvrPixel.px40 - IvrPixel.px146;
    //height -=  IvrPixel.px146;
    //var height = Adapt.screenH() - 60 - 132 - 40 - 146;
    var h2 = height / IvrPixel.px2082;

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: IvrPixel.px475 * h2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[

                        Text(
                          "等待下单中...",
                          style: IvrStyle.getFont60(),
                        ),
                        SizedBox(
                          height: IvrPixel.px29,
                        ),
                        RichText(
                          text: TextSpan(
                              style: IvrStyle.getFont36(),
                              text: "（下单后会",
                              children: [
                                TextSpan(
                                    text: "自动刷新",
                                    style: IvrStyle.getFont36(color: IvrColor.c95F9DE)),
                                TextSpan(text: "本页，无须手动操作）"),
                              ]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Image(
                image: IvrAssets.getPng("Illustration"),
                width: IvrPixel.px1125 * h2,
                height: IvrPixel.px1100 * h2,
              ),
              SizedBox(
                height: IvrPixel.px482 * h2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image(
                          image: IvrAssets.getPng("icon_up"),
                          width: IvrPixel.px60,
                          height: IvrPixel.px51,
                        ),
                        SizedBox(
                          height: IvrPixel.px24,
                        ),
                        RichText(
                          text: TextSpan(
                              style: IvrStyle.getFont36(),
                              text: "上滑 可",
                              children: [
                                TextSpan(
                                    text: "手动",
                                    style: IvrStyle.getFont36(color: IvrColor.c95F9DE)),
                                TextSpan(text: "选择游戏和背包电脑"),
                              ]),
                        ),
                        SizedBox(
                          height: IvrPixel.px132 * h2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OneBattleSelectPCPanel2 extends IvrStatefulWidget<OneGameData> {
  OneBattleSelectPCPanel2([IvrData d]) : super(data: d);

  @override
  OneBattleSelectPCPanel2State createState() => OneBattleSelectPCPanel2State();
}

class OneBattleSelectPCPanel2State
    extends IvrWidgetState<OneBattleSelectPCPanel2> {
  OneBattleSelectPCPanel4 panel4;

  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    var height = Adapt.screenH() - IvrPixel.px60 - IvrPixel.px132 - IvrPixel.px40 - IvrPixel.px146;
    //height -=  IvrPixel.px146;
    var h2 = height / IvrPixel.px2082;
    //var h3 = height / IvrPixel.px2082;

    return ConstrainedBox(
      //height: IvrPixel.px2082 * h2,
      constraints: BoxConstraints(
        minHeight: IvrPixel.px2082 * h2,
      ),
      child: Transform.scale(scale: 1, child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: IvrPixel.px79 * h2,
              ),
              OneBattleSelectPCPanel3(data),
              panel4 = OneBattleSelectPCPanel4(data),
              IvrButton(
                "确定",
                IvrPixel.px600,
                callback: () {
                  print("请求开始游戏");

                  var bagCheckedMap = panel4.s.bagCheckedMap;
                  var clients = List<String>();
                  bagCheckedMap.forEach((k, v) {
                    if (v) {
                      clients.add(k);
                    }
                  });
                  if (clients.length > data.seatCount) {
                    OneDialog.showDialogOk(context, "背包电脑数量过多");
                    return;
                  }

                  // 弹出对话框
                  OneDialog.showDialogOkCancel(context, "确定要下单吗？", () {}, () {
                    print(bagCheckedMap);

                    Application.connection.openGame(data.gameServer.id, clients);
                    showBlockDialog(2, context);
                    bagCheckedMap.clear();
                  });
                },
              ),
            ],
          )),)  ,
    );
  }
}

// 选择游戏内容
class OneBattleSelectPCPanel3 extends IvrStatefulWidget<OneGameData> {
  OneBattleSelectPCPanel3([IvrData d]) : super(data: d);

  @override
  OneBattleSelectPCPanel3State createState() => OneBattleSelectPCPanel3State();
}

// 选择本场游戏
class OneBattleSelectPCPanel3State
    extends IvrWidgetState<OneBattleSelectPCPanel3> {
  int groupValue = 0;

  onChanged(v) {
    setState(() {
      groupValue = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    return Container(
      margin: EdgeInsets.fromLTRB(IvrPixel.px40,IvrPixel.px0,IvrPixel.px40,IvrPixel.px40),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                0, IvrPixel.px10, IvrPixel.px10, IvrPixel.px32),
            child: IvrTitle1("选择本场游戏内容"),
          ),
          IvrPanel(
            SizedBox(
              height: IvrPixel.px480,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    OneBattleSelectPCPanel3One1(groupValue, 0, onChanged),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 选择本场游戏
class OneBattleSelectPCPanel3One1 extends StatelessWidget {
  int groupValue;
  int value;
  final ValueChanged<int> onChanged;

  OneBattleSelectPCPanel3One1(this.groupValue, this.value, this.onChanged)
      : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        this.value == 0
            ? Container()
            : IvrDivider(margin: EdgeInsets.fromLTRB(IvrPixel.px28, 0, 0, 0)),
        Container(
          margin: EdgeInsets.fromLTRB(
              IvrPixel.px33, IvrPixel.px26, IvrPixel.px33, IvrPixel.px26),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: SizedBox(
                  height: IvrPixel.px110,
                  //width: Pixel.px966,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          //SizedBox(width: Pixel.px10,),
                          Image(image: IvrAssets.getPng("game_icon1")),
                          SizedBox(
                            width: IvrPixel.px41,
                          ),
                          Text("末日营救2071", style: IvrStyle.getFont44()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IvrRadio(groupValue == value),
                          SizedBox(
                            width: IvrPixel.px51,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onChanged(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 选择背包电脑
class OneBattleSelectPCPanel4 extends IvrStatefulWidget<OneGameData> {
  OneBattleSelectPCPanel4([IvrData d]) : super(data: d);

  OneBattleSelectPCPanel4State s;

  @override
  OneBattleSelectPCPanel4State createState() => OneBattleSelectPCPanel4State();
}

class OneBattleSelectPCPanel4State
    extends IvrWidgetState<OneBattleSelectPCPanel4> {
  Map<String, bool> bagCheckedMap;

  void checkVariable() {
    widget.s = this;

    if (bagCheckedMap == null) {
      bagCheckedMap = new Map<String, bool>();
    }

    widget.data.clients.forEach((k, v) {
      {
        if (!bagCheckedMap.containsKey(k)) {
          bagCheckedMap[k] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    checkVariable();

    var widgets = List<OneBattleSelectPCPanel4One>();
    data.clients.forEach((k, v) {
      widgets.add(
          OneBattleSelectPCPanel4One(v, widgets.length, bagCheckedMap[k], (b) {
        bagCheckedMap[k] = !bagCheckedMap[k];
        setState(() {

        });
      }));
    });

    return Container(
      margin: EdgeInsets.fromLTRB(IvrPixel.px40,IvrPixel.px0,IvrPixel.px40,IvrPixel.px40),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                0, IvrPixel.px10, IvrPixel.px10, IvrPixel.px32),
            child: IvrTitle1("选择背包电脑",
                rightChild: Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          style: IvrStyle.getFont36(color: IvrColor.c7F7F7F),
                          text: "最多可开启 ",
                          children: [
                            TextSpan(
                                text: "${data.seatCount}台",
                                style: IvrStyle.getFont36(
                                    color: IvrColor.c95F9DE)),
                          ]),
                    ),
                  ],
                )),
          ),
          SingleChildScrollView(
            child: IvrPanel(Column(
              children: widgets,
            )),
          ),
        ],
      ),
    );
  }
}

class OneBattleSelectPCPanel4One extends StatelessWidget {
  final int idx;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final GameClientStateData data;

  OneBattleSelectPCPanel4One(
      this.data, this.idx, this.selected, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        this.idx == 0
            ? Container()
            : IvrDivider(margin: EdgeInsets.fromLTRB(IvrPixel.px28, 0, 0, 0)),
        Container(
          margin: EdgeInsets.fromLTRB(
              IvrPixel.px33, IvrPixel.px26, IvrPixel.px33, IvrPixel.px26),
          child: Column(
            children: <Widget>[
              GestureDetector(
                behavior:HitTestBehavior.translucent,
                child: SizedBox(
                  height: IvrPixel.px110,
                  //width: Pixel.px966,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          //SizedBox(width: Pixel.px10,),
                          Image(
                            image: IvrAssets.getPng("icon_pc"),
                            width: IvrPixel.px108,
                            height: IvrPixel.px108,
                          ),
                          SizedBox(
                            width: IvrPixel.px41,
                          ),
                          //Text("背包电脑：${this.data.id}", style: IvrStyle.getFont44()),
                          RichText(
                            text: TextSpan(
                                style: IvrStyle.getFont44(),
                                text: "背包电脑：",
                                children: [
                                  TextSpan(
                                      text: "${data.id}",
                                      style: IvrStyle.getFont44(
                                          color: IvrColor.c95F9DE)),
                                ]),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IvrCheck(
                            this.selected,
                            onChanged: onChanged,
                          ),
                          SizedBox(
                            width: IvrPixel.px51,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onChanged(!this.selected);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
