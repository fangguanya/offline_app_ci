import 'package:flutter/material.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:operator_controller/panel/sharing/team_photo.dart';
import 'package:operator_controller/panel/sharing/team_player.dart';
import '../style.dart';
import 'package:flutter/services.dart';
import 'package:operator_controller/dialogs/toast.dart';

// 视频录制的分页
class VideoRecord extends IvrStatefulWidget<IvrData> {
  int selectedIndex = 0;
  String defaultName;
  void setServerSelect(int i) {
    selectedIndex = i;

    // 请求
    var tag = Application.dataCenter.sharing.getServerTag(selectedIndex);
    Application.dataCenter.sharing.getOrCreateRoom(tag);
  }

  VideoRecord(this.selectedIndex, this.defaultName, [IvrData d]) : super(evtId: UIID.UI_Sharing) {
    setServerSelect(this.selectedIndex);
  }

  @override
  VideoRecordState createState() => VideoRecordState();
}

class VideoRecordState extends IvrWidgetState<VideoRecord> {
  @override
  Widget build(BuildContext context) {
    // 可选择的服务器列表
    var serverSelectTitle = IvrTitle(RichText(
      text:
          TextSpan(style: IvrStyle.getFont48(), text: "第1步：选择进程", children: []),
    ));
    var serverSelectList = new List<Widget>();
    for (int i = 0; i < Application.dataCenter.sharing.getServerCount(); i++) {
      serverSelectList.add(
          IvrTextRadio(Application.dataCenter.sharing.getServerName(i), () {
        setState(() {
          widget.setServerSelect(i);
        });
      }, (i == widget.selectedIndex) ? true : false));
    }

    // 房间和玩家属性配置
    String tag =
        Application.dataCenter.sharing.getServerTag(widget.selectedIndex);
    var team = Application.dataCenter.sharing.getTeamWithTag(tag);
    var list = new List<Widget>();
    if (team != null) {
      list.add(IvrRecordTeamImageWidget(tag, team.images, team.coverimg));
      list.add(IvrDivider(
        margin: EdgeInsets.fromLTRB(IvrPixel.px20, 0, 0, 0),
      ));
      list.add(Container(
          margin: EdgeInsets.fromLTRB(
              IvrPixel.px55, IvrPixel.px20, IvrPixel.px55, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IvrTitle(RichText(
                text: TextSpan(
                    style: IvrStyle.getFont48(),
                    text: "第3步：设置玩家名称",
                    children: []),
              )),
            ],
          )));

      // TODO:根据当前选择得游戏决定玩家得最多数目
      int maxPlayer = 4;  // 解谜项目应该是5个
      for (int i = 0; i < team.players.length && i < maxPlayer; i++) {
        list.add(IvrRecordTeamPlayerWidget(tag, team.players[i].valid, i, "玩家${i+1}"));
      }
      list.add(IvrDivider(
        margin: EdgeInsets.fromLTRB(IvrPixel.px20, 0, 0, 0),
      ));
      list.add(Container(
          margin: EdgeInsets.fromLTRB(
              IvrPixel.px55, IvrPixel.px20, IvrPixel.px55, IvrPixel.px40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IvrTitle(RichText(
                text: TextSpan(
                    style: IvrStyle.getFont48(),
                    text: "第4步：设置团队名称",
                    children: []),
              )),
              SizedBox(
                width: IvrPixel.px350,
                child: IvrTextField(
                  defaultContent: team.nickname,
                  color: team.nickname == widget.defaultName ? IvrColor.cE8E8E8 : IvrColor.c79F7AD,
                  onEditComplete: (n) {
                    print("编辑完成,队伍名称=$n,之前=${team.nickname}");
                    if (n != team.nickname) {
                      Application.dataCenter.sharing
                          .setTeamBaseInformation(tag, n);
                    }
                  },
                ),
              ),
            ],
          )));
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: IvrColor.c000000,
          appBar: AppBar(
            title: Stack(
              children: <Widget>[
                Center(
                  child: Text("生成分享视频"),
                )
              ],
            ),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                height: IvrPixel.px150,
                margin: EdgeInsets.fromLTRB(
                    IvrPixel.px20, IvrPixel.px20, IvrPixel.px20, IvrPixel.px20),
                child: IvrPanel(
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: IvrPixel.px65,
                      ),
                      serverSelectTitle,
                      Expanded(
                        child: Container(
//                            color: IvrColor.c313131,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: serverSelectList)),
                      )
                    ],
                  ),
                ),
              ),
              IvrFocusGestureDetector(
                  child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      IvrPixel.px20, 0, IvrPixel.px20, IvrPixel.px20),
                  child: Column(
                    children: <Widget>[
                      IvrPanel(
                        Container(
                          child: Column(
                            children: list,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Container(
                  margin: EdgeInsets.fromLTRB(
                      IvrPixel.px20, IvrPixel.px20, IvrPixel.px20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//                      IvrButton(
//                        "生成视频",
//                        IvrPixel.px295,
//                        callback: () {
//                          print("生成视频!");
//                          if (team == null) {
//                            OneDialog.showDialogOk(context, '房间信息不正确!');
//                          } else {
//                            Application.dataCenter.sharing
//                                .startGenerateRecord(tag);
//                          }
//                        },
//                      ),
//                      SizedBox(
//                        width: IvrPixel.px40,
//                      ),
                      IvrButton(
                        "拷贝视频链接",
                        IvrPixel.px375,
                        disable: (team == null ||
                            team.videourl15 == null ||
                            team.videourl15.length <= 0),
                        callback: () {
                          if (team == null) {
                            OneDialog.showDialogOk(context, '房间信息无效!');
                          } else if (team.videourl15 == null ||
                              team.videourl15.length <= 0) {
                            OneDialog.showDialogOk(context, '视频还未生成完毕!');
                          } else {
                            Toast.show("拷贝链接=${team.videourl15}");
                            print("拷贝链接=${team.videourl15}");
                            Clipboard.setData(
                                ClipboardData(text: team.videourl15));
                          }
                        },
                      ),
                    ],
                  )),
              Text(
                getProgressDesc(),
                textAlign: TextAlign.center,
                style: IvrStyle.getFont48(color: getColor()),
              ),
              SizedBox(
                height: IvrPixel.px272,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color getColor() {
    var tag = Application.dataCenter.sharing.getServerTag(widget.selectedIndex);
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
    var tag = Application.dataCenter.sharing.getServerTag(widget.selectedIndex);
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
