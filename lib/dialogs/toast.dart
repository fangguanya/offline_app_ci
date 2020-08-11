import 'package:flutter/material.dart';
import 'package:operator_controller/logic/application.dart';

import 'toastnew.dart';

class Toast {
  static void show(String message, {int duration}) async{

    if(Application.isNew()) {
      return ToastNew.show(message, duration : duration);
    }


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
    Overlay.of(Application.context).insert(entry);
    Future.delayed(Duration(seconds: duration ?? 3)).then((value) {
      // 移除层可以通过调用OverlayEntry的remove方法。
      entry.remove();
    });
  }
}


// 常用的对话框
class OneDialog {

  // 确定取消的提示框
  static void showDialogOkCancel(BuildContext context, String text, [VoidCallback cancel, VoidCallback ok]) {

    if(Application.isNew()) {
      return OneDialogNew.showDialogOkCancel(context, text, cancel, ok);
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              textColor: Colors.white,
              color: Colors.orange,
              onPressed: () {
                Navigator.of(context).pop();
                if(cancel != null) {
                  cancel();
                }
              },
            ),
            FlatButton(
              child: Text('确定'),
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
                if(ok != null) {
                  ok();
                }
              },
            ),
          ],
        );
      },
    );
  }
  // 确定取消的提示框
  static void showDialogOk(BuildContext context, String text, [VoidCallback ok]) {

    if(Application.isNew()) {
      return OneDialogNew.showDialogOk(context, text, ok);
    }

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
                if(ok != null) {
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