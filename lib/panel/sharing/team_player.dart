import 'package:flutter/material.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/battle/widget.dart';

import '../style.dart';

// 单个玩家的配置信息
//  - 标签/背包电脑ID/名字可编辑
class IvrRecordTeamPlayerWidget extends IvrStatefulWidget<IvrData> {
  String serverTag;
  int index;
  bool valid;
  String defaultName;

  IvrRecordTeamPlayerWidget(this.serverTag, this.valid, this.index, this.defaultName, [IvrData d])
      : super(data: d);

  @override
  IvrRecordTeamPlayerState createState() => IvrRecordTeamPlayerState();
}

class IvrRecordTeamPlayerState
    extends IvrWidgetState<IvrRecordTeamPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.serverTag == null || widget.serverTag.length <= 0) {
      return Container();
    }

//    print("player=${widget.index}");
    var p = Application.dataCenter.sharing
        .getPlayerWithTag(widget.serverTag, widget.index);
    if (p == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        IvrDivider(
          margin: EdgeInsets.fromLTRB(IvrPixel.px20, 0, 0, 0),
        ),
        Container(
          height: IvrPixel.px188,
          margin:
              EdgeInsets.fromLTRB(IvrPixel.px62, IvrPixel.px2, 0, IvrPixel.px2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: IvrPixel.px65,
                  ),
                  Container(
                    //margin: EdgeInsets.fromLTRB(0, IvrPixel.px10, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(getPlayerDesc(),
                            style: IvrStyle.getFont44(color: IvrColor.cFFFFFF)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IvrCheck(
                    widget.valid,
                    onChanged: (b) {
                      if (b != widget.valid) {
                        widget.valid = b;
                        setPlayerNickName(getPlayerName(), widget.valid);
                      }
                    },
                  ),
                  SizedBox(
                    width: IvrPixel.px350,
                    child: IvrTextField(
                      defaultContent: getPlayerName(),
                      color: getPlayerNameColor(),
                      onEditComplete: (n) {
                        print(
                            "玩家=${getPlayerDesc()}编辑完成,名称=$n,之前=${getPlayerName()}");
                        if (n != getPlayerName()) {
                          setPlayerNickName(n, widget.valid);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: IvrPixel.px65,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String getPlayerDesc() {
    if (widget.serverTag == "s1") {
      return "电脑${widget.index + 41}号的玩家:";
    } else if (widget.serverTag == "s2") {
      return "电脑${widget.index + 45}号的玩家:";
    } else {
      return "玩家${widget.index + 1}:";
    }
  }

  Color getPlayerNameColor(){
    var p = Application.dataCenter.sharing
        .getPlayerWithTag(widget.serverTag, widget.index);
    if (p == null) {
      return IvrColor.cE8E8E8;
    } else {
      if (p.nickname == widget.defaultName){
        return IvrColor.cE8E8E8;
      }
      return IvrColor.c79F7AD;
    }
  }

  String getPlayerName() {
    var p = Application.dataCenter.sharing
        .getPlayerWithTag(widget.serverTag, widget.index);
    if (p == null) {
      return "INVALID";
    } else {
      return p.nickname;
    }
  }

  void setPlayerNickName(String name, bool enable) {
    Application.dataCenter.sharing.setPlayerNickName(widget.serverTag, widget.index, name, enable);
    print("设置玩家信息:tag=${widget.serverTag},index=${widget.index},name=$name,");
  }
}
