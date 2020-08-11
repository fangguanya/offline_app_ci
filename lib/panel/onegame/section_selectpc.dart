import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/block_dialog.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';

import '../style.dart';

//段落1
// 选择要启动的背包电脑
class SectionSelectPc extends IvrStatefulWidget<OneGameData> {

  SectionSelectPc([OneGameData d]) : super(data:d);

  @override
  SectionSelectPcState createState() =>SectionSelectPcState();
}

class SectionSelectPcState extends IvrWidgetState<SectionSelectPc> {

  Map<String, bool> bagCheckedMap;

  void checkVariable() {
    if(bagCheckedMap == null) {
      bagCheckedMap = new Map<String, bool>();
    }

    widget.data.clients.forEach((k, v){
      {
        if(!bagCheckedMap.containsKey(k)) {
          bagCheckedMap[k] = false;
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool checkNeedFirstClose(OneGameData data, Column widgets) {
    bool needkill = false;

    if (data.gameServer.online) {
      needkill = true;
    }
    data.clients.forEach((k, v) {
      if (v.online) {
        needkill = true;
      }
      var m = Application.dataCenter.getPcAdjustMonitor(v.id);
      if(m != null && m.isRunning('fixer.exe')) {
          needkill = true;
      }
    });

    if (needkill) {
      widgets.children.add(Text('需要先关闭如下设备', textScaleFactor: 1.3, style: IvrStyle.warningStyle,));

      if (data.gameServer.online) {
        widgets.children.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('服务器:' + data.gameServer.id),
            SizedBox(width: 20,),
            ButtonTheme(height: 28,
            minWidth: 64,
            buttonColor: Colors.grey[300],
            child: RaisedButton(
              child: Text('关闭'),
              onPressed: () {
                Application.connection.closeGameClient(data.gameServer.id);
              },),
            )
          ],
        ));
      }

      data.clients.forEach((k, v) {
        if (v.online) {
          widgets.children.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('客户端:' + v.id),
              SizedBox(width: 20,),
              ButtonTheme(height: 28,
                minWidth: 64,
                buttonColor: Colors.grey[300],
                child: RaisedButton(
                  child: Text('关闭'),
                  onPressed: () {
                    Application.connection.closeGameClient(v.id);
                  },),
              ),
            ],
          ));
        }

        var m = Application.dataCenter.getPcAdjustMonitor(v.id);
        if(m != null && (m.isRunning('fixer.exe') || m.isRunning('spacetest.exe'))) {
          widgets.children.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('矫准程序:' + v.id),
              SizedBox(width: 20,),
              ButtonTheme(height: 28,
                minWidth: 64,
                buttonColor: Colors.grey[300],
                child: RaisedButton(
                  child: Text('关闭'),
                  onPressed: () {
                    m.turnOff('fixer.exe');
                    m.turnOff('spacetest.exe');
                  },),
              ),
            ],
          ));
        }
      });

      widgets.children.add(RaisedButton(
          child: Text("关闭以上设备"),
          onPressed: () {
            if (data.gameServer.online) {
              Application.connection.closeGameClient(data.gameServer.id);
            }
            data.clients.forEach((k, v) {
              if (v.online) {
                Application.connection.closeGameClient(k);
              }

              var m = Application.dataCenter.getPcAdjustMonitor(v.id);
              if(m != null && (m.isRunning('fixer.exe') || m.isRunning('spacetest.exe'))) {
                m.turnOff('fixer.exe');
                m.turnOff('spacetest.exe');
              }
            });
          }));
    }
    return needkill;
  }

  @override
  Widget build(BuildContext context) {

    var data = widget.data;
    if(data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    if(data.timeout) {
      return Text('网络超时了，请检查中控服务器', textAlign: TextAlign.center,);
    }

    if(data.gameFlag == Constants.GameFlagNoGame || data.gameFlag == Constants.GameFlagCloseGame) {

    } else {
      //return Text('游戏状态:${data.gameFlag}');
      return Container();
    }

    checkVariable();

    // TODO: implement build
    var widgets = Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child:Text("请选择背包电脑",
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
          ),
        ),
      ],
    );

    var b = checkNeedFirstClose(data, widgets);
    if(b) {
      return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: widgets,
        );
    }

    widgets.children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('可以启动的背包电脑数量：'),
        Text('${data.seatCount}', style: IvrStyle.getWarningTextStyle(true), textScaleFactor: 1.2,)
      ],)
    );

    data.clients.forEach((k, v) {
      widgets.children.add(
          Center(
              child: CheckboxListTile(
                  value: bagCheckedMap[k],
                  title: Text('背包电脑:${v.id}', style: IvrStyle.getWarningTextStyle(Application.dataCenter.isSeatRead(v.id)),),
                  onChanged: (b){
                    setState(() {
                      bagCheckedMap[k] = b;
                    });
                  })
          )
      );
    });

    widgets.children.add(Align(
        alignment: Alignment.center,
        child:RaisedButton(
          child:Text("确定"),
          onPressed: () {


            var clients = List<String>();
            bagCheckedMap.forEach((k, v) {
              if(v) {
                clients.add(k);
              }
            });
            if(clients.length > data.seatCount) {
              OneDialog.showDialogOk(context, "背包电脑数量过多");
              return;
            }

            // 弹出对话框
            OneDialog.showDialogOkCancel(context, "确定吗？",
                    (){},
                    () {
                  print(bagCheckedMap);

                  Application.connection.openGame(data.gameServer.id, clients);
                  showBlockDialog(2, context);
                  bagCheckedMap.clear();
                });
          },
        )
    ));

    return widgets;
  }

}
