import 'dart:math';

import 'package:flutter/material.dart';
import 'package:operator_controller/logic/adapt.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/panel/device/allhardware.dart';

import '../style.dart';
import 'gameviewport_alldevices.dart';
import 'widget.dart';

/**
 * Auth :   liubo
 * Date :   2020/5/6 10:17
 * Comment: 游戏地图
 */

class BattleMap extends IvrStatefulWidget<IvrData> {
  BattleMap([IvrData d]) : super(data: d, evtId: UIID.UI_BattleMap);

  @override
  BattleMapState createState() => BattleMapState();
}

class BattleMapState extends IvrWidgetState<BattleMap> {
  NewMyGameviewportAllDevices mygame;

  @override
  Widget build(BuildContext context) {
    var pad40 = IvrPixel.px40;

    if (mygame == null) {
      mygame = NewMyGameviewportAllDevices(width: IvrPixel.px1045);
    }

    var s1 = Application.dataCenter.gameDatas["s1"];
    var s2 = Application.dataCenter.gameDatas["s2"];

    var clientList = new Map<String, GameClientStateData>();

    if (s1 != null && s1.isPlaying()) {
      s1.clients.forEach((k, v) {
        clientList[k] = v;
      });
    }

    if (s2 != null && s2.isPlaying()) {
      s2.clients.forEach((k, v) {
        clientList[k] = v;
      });
    }

    mygame.setGameDataUseList(clientList);

    var hardwareInfo = new List<HardwareInfo>();

    // 测试数据
//    var testCount = 11;
//    for (int i = 0; i < testCount; i++) {
//      var one = HardwareInfo();
//      one.online = i % 3 == 0;
//      hardwareInfo.add(one);
//    }

    bool hasException = false;

    Application.dataCenter.hardwareRelations.forEach((rel) {
      if (rel.type != DeviceType.HSERVER) {
        return;
      }

      Device d = Application.dataCenter.getHardwareByRelation(rel);
      var one = HardwareInfo();
      one.name = rel.name;
      one.online = gIsOnline(d);
      one.valid = true;
      one.icon = getHarewareIconSmall(rel, d);

      hasException |= !one.online;

      hardwareInfo.add(one);
    });

    Application.dataCenter.hardwareRelations.forEach((rel) {
      if (rel.type != DeviceType.ELEVATOR) {
        return;
      }

      Device d = Application.dataCenter.getHardwareByRelation(rel);
      var one = HardwareInfo();
      one.name = rel.name;
      one.online = gIsOnline(d);
      one.valid = true;
      one.icon = getHarewareIconSmall(rel, d);

      hasException |= !one.online;

      hardwareInfo.add(one);
    });

    Application.dataCenter.hardwareRelations.forEach((rel) {
      if (rel.type == DeviceType.HSERVER) {
        return;
      }

      if (rel.type == DeviceType.ELEVATOR) {
        return;
      }

      Device d = Application.dataCenter.getHardwareByRelation(rel);
      var one = HardwareInfo();
      one.name = rel.name;
      one.online = gIsOnline(d);
      one.valid = true;
      one.icon = getHarewareIconSmall(rel, d);

      hasException |= !one.online;

      hardwareInfo.add(one);
    });

    if (hardwareInfo.length % 2 != 0) {
      var one = HardwareInfo();
      one.valid = false;
      hardwareInfo.add(one);
    }
    var hardwareList = new List<BattleHardwareOneLine>();
    for (int i = 0; i < hardwareInfo.length; i += 2) {
      hardwareList.add(BattleHardwareOneLine(
          (i / 2) % 2 == 1, hardwareInfo[i], hardwareInfo[i + 1]));
    }
    if (hardwareList.length > 0) {
      hardwareList[hardwareList.length - 1].lastOne = true;
    }

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, IvrPixel.px41, 0, 0),
          child: SizedBox(
            width: IvrPixel.px1045,
            height: IvrPixel.px1490,
            child: Stack(
              children: <Widget>[
                //Image(image: ImageAssets.getPng("map")),
                Stack(
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.fromLTRB(0, Pixel.px40, 0, 0),
                      child: mygame.widget,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(
                          IvrPixel.px48, IvrPixel.px24, 0, 0),
                      height: IvrPixel.px80,
                      child: Row(
                        children: <Widget>[
                          s1 != null && s1.isPlaying()
                              ? Row(
                                  children: <Widget>[
                                    Image(
                                      image: IvrAssets.getPng("player1"),
                                      width: IvrPixel.px56,
                                      height: IvrPixel.px56,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        '${s1.gameServer.gameName}',
                                        style: IvrStyle.getFont36(
                                            color: IvrColor.cCCCCCC),
                                      ),
                                      width: IvrPixel.px300,
                                    ),
                                  ],
                                )
                              : Container(),
                          s2 != null && s2.isPlaying()
                              ? Row(
                                  children: <Widget>[
                                    Image(
                                      image: IvrAssets.getPng("player2"),
                                      width: IvrPixel.px56,
                                      height: IvrPixel.px56,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        '${s2.gameServer.gameName}',
                                        style: IvrStyle.getFont36(
                                            color: IvrColor.cCCCCCC),
                                      ),
                                      width: IvrPixel.px300,
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          margin:
              EdgeInsets.fromLTRB(pad40, IvrPixel.px53, pad40, IvrPixel.px32),
          child: IvrTitle1("场地硬件情况",
              rightChild: !hasException
                  ? null
                  : Row(
                      children: <Widget>[
                        Image(
                          image: IvrAssets.getPng("icon_warning"),
                          width: IvrPixel.px38,
                          height: IvrPixel.px34,
                        ),
                        SizedBox(
                          width: IvrPixel.px14,
                        ),
                        Text("有异常情况",
                            style: IvrStyle.getFont36(color: IvrColor.cFF7D7D)),
                      ],
                    )),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(pad40, 0, pad40, pad40),
          height: IvrPixel.px120 * max<int>(1, (hardwareList.length).ceil()),
          width: IvrPixel.px1045,
          decoration: new BoxDecoration(
            color: IvrColor.c1C1C1D,
            borderRadius: BorderRadius.all(Radius.circular(IvrPixel.px26)),
          ),
          child: Column(
            children: hardwareList,
          ),
        ),
        SizedBox(
          height: IvrPixel.px324,
        ),
      ],
    ));
  }
}

class HardwareInfo {
  var icon = "icon_equipment_server_fault";
  var name = "中控服务器";
  var online = false;
  var valid = true;

  HardwareInfo();
}

class BattleHardwareOneLine extends StatelessWidget {
  final bool bg;
  final HardwareInfo data1;
  final HardwareInfo data2;
  bool lastOne = false;

  BattleHardwareOneLine(this.bg, this.data1, this.data2) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: IvrPixel.px120,
      decoration: !this.bg
          ? null
          : new BoxDecoration(
              color: IvrColor.c121212,
              borderRadius: BorderRadius.vertical(
                  bottom:
                      lastOne ? Radius.circular(IvrPixel.px26) : Radius.zero),
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BattleHardwareState(this.data1),
          BattleHardwareState(this.data2),
        ],
      ),
    );
  }
}

class BattleHardwareState extends StatelessWidget {
  final HardwareInfo data;

  BattleHardwareState(this.data) : super();

  @override
  Widget build(BuildContext context) {
    return !this.data.valid
        ? Container(
            width: IvrPixel.px1045 / 2,
          )
        : Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: IvrPixel.px33,
                ),
                Image(
                  image: IvrAssets.getPng("${this.data.icon}"),
                  width: IvrPixel.px70,
                  height: IvrPixel.px70,
                  color: !this.data.online ? IvrColor.cFF7D7D : Colors.grey,
                ),
                SizedBox(
                  width: IvrPixel.px16,
                ),
                SizedBox(
                  width: IvrPixel.px296,
                  child: Text(
                    '${this.data.name}',
                    style: IvrStyle.getFont40(
                        color: !this.data.online ? IvrColor.cFF7D7D : null),
                  ),
                ),
                Image(
                  image: IvrAssets.getPng(
                      this.data.online ? "icon_online" : "icon_offline"),
                  width: IvrPixel.px36,
                  height: IvrPixel.px36,
                ),
                SizedBox(
                  width: IvrPixel.px24 + IvrPixel.px44,
                ),
              ],
            ),
          );
  }
}
