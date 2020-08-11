import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:operator_controller/logic/application.dart';

/**
 * Auth :   liubo
 * Date :   2019/9/24 22:19
 * Comment: 阻塞对话框
 */

// https://juejin.im/post/5c0aa283518825444612a1eb
bool bShowMyCustomLoadingDialog = false;
void showBlockDialog(int seconds, BuildContext context) {

  if(bShowMyCustomLoadingDialog) {
    return;
  }
  bShowMyCustomLoadingDialog = true;

  showDialog(
      context: Application.navState.currentContext,
      barrierDismissible: false,
      builder: (context) {
        return new MyCustomLoadingDialog();
      });

  Timer(Duration(seconds: seconds), (){
    bShowMyCustomLoadingDialog = false;
    Navigator.of(Application.navState.currentContext).pop();
  });
}

class MyCustomLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = const Duration(milliseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)));

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Material(
              elevation: 24.0,
              color: Theme.of(context).dialogBackgroundColor,
              type: MaterialType.card,
              //在这里修改成我们想要显示的widget就行了，外部的属性跟其他Dialog保持一致
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: new Text("加载中"),
                  ),
                ],
              ),
              shape: _defaultDialogShape,
            ),
          ),
        ),
      ),
    );
  }
}
