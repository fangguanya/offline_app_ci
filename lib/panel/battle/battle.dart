import 'package:flutter/material.dart';
import 'package:operator_controller/logic/adapt.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/logic/application.dart';

import '../style.dart';
import 'battle_map.dart';
import 'ivr_tab_indicator.dart';
import 'onebattle.dart';

/**
 * Auth :   liubo
 * Date :   2020/5/6 9:23
 * Comment: 一场战斗，包括：地图，游戏进程1，游戏进程2
 */

class Battle extends IvrStatefulWidget<IvrData> {
  Battle([IvrData d]) : super(data: d);

  @override
  BattleState createState() => BattleState();
}

class BattleState extends IvrWidgetState<Battle> {
  int tabIdx = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tabIdx,
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(
          title: TabBar(
              onTap: (idx) {
                setState(() {
                  Application.dataCenter.sharing.getOrCreateRoom("s1");
                  Application.dataCenter.sharing.getOrCreateRoom("s2");
                  tabIdx = idx;
                });
              },
              labelStyle: IvrStyle.getFont48(),
              unselectedLabelColor: Color(0xFF7F7F7F),
              labelColor: IvrColor.c95F9DE,
              indicatorColor: IvrColor.c95F9DE,
              indicatorPadding:
                  EdgeInsets.only(left: IvrPixel.px130, right: IvrPixel.px130),
              indicatorWeight: IvrPixel.px10,
              indicator: IvrUnderlineTabIndicator(
                specialWidth: IvrPixel.px80,
                  borderSide: BorderSide(
                      color: IvrColor.c95F9DE, width: IvrPixel.px10)),
              tabs: [
                Tab(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: IvrAssets.getPng(tabIdx == 0
                              ? "icon_map_selected"
                              : "icon_map_normal"),
                          width: Adapt.px(64),
                          height: Adapt.px(64),
                        ),
                        SizedBox(
                          width: Adapt.px(20),
                        ),
                        Text(
                          "地图",
                        )
                      ],
                    ),
                  ),
                ),
                Tab(
                    child: Text(
                  "游戏进程1",
                )),
                Tab(
                    child: Text(
                  "游戏进程2",
                )),
              ]),
        ),
        body: TabBarView(children: [
          BattleMap(),
          OneBattle("s1"), //Icon(Icons.directions_transit),
          OneBattle("s2"), //Icon(Icons.directions_bike)
        ]),
      ),
    );
  }
}
