import 'package:flutter/material.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:operator_controller/panel/style.dart';

class ToastNew {
  static void show(String message, {int duration}) async {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.7,
        ),
        alignment: Alignment.center,
        child: Center(
          child: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Material(
                child: Text(
                  message,
                  style: TextStyle(),
                ),
              ),
            ),
          ),
        ),
      );
    });
//    Overlay.of(Application.context).insert(entry);
    Application.navState.currentState.overlay.insert(entry);
    Future.delayed(Duration(seconds: duration ?? 3)).then((value) {
      // 移除层可以通过调用OverlayEntry的remove方法。
      entry.remove();
    });
  }
}

// 常用的对话框
class OneDialogNew {
  // 确定取消的提示框
  static void showDialogOkCancel(BuildContext context, String text,
      [VoidCallback cancel, VoidCallback ok]) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: IvrPixel.px940,
            height: IvrPixel.px456,
            child: Container(
              child: IvrPanel(Container(
                margin: EdgeInsets.fromLTRB(
                    IvrPixel.px47, IvrPixel.px57, IvrPixel.px47, IvrPixel.px57),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: IvrPixel.px150,
                      child: Center(
                        child: Text(
                          "$text",
                          style: IvrStyle.getFont52(color: IvrColor.cFFFFFF),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IvrButton3(
                          "取消",
                          IvrPixel.px410,
                          callback: () {
                            Navigator.of(context).pop();
                            if (cancel != null) {
                              cancel();
                            }
                          },
                        ),
                        IvrButton(
                          "确定",
                          IvrPixel.px410,
                          callback: () {
                            Navigator.of(context).pop();
                            if (ok != null) {
                              ok();
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ),
          ),
        );
      },
    );
  }

  // 确定取消的提示框
  static void showDialogOk(BuildContext context, String text,
      [VoidCallback ok]) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: IvrPixel.px940,
            height: IvrPixel.px456,
            child: Container(
              child: IvrPanel(Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, -IvrPixel.px230),
                    child: Center(
                      child: Image(
                        image: IvrAssets.getPng("icon_warning"),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(IvrPixel.px47, IvrPixel.px67,
                        IvrPixel.px47, IvrPixel.px57),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: IvrPixel.px150,
                          child: Center(
                            child: Text(
                              "$text",
                              style:
                                  IvrStyle.getFont52(color: IvrColor.cFFFFFF),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IvrButton3(
                              "知道了",
                              IvrPixel.px846,
                              callback: () {
                                Navigator.of(context).pop();
                                if (ok != null) {
                                  ok();
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
        );
      },
    );
  }

  static void showDialogOk2(BuildContext context, String text,
      [VoidCallback ok]) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
                if (ok != null) {
                  ok();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
