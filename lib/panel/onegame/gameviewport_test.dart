
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:operator_controller/models/core/provider.dart';

import 'gameviewport.dart';

/**
 * Auth :   liubo
 * Date :   2019/11/6 17:26
 * Comment: 测试gameviewport
 */

class HmdPosition extends IvrData {
  String text = "0 0 0";
  double x, y, angle;
  void setText(String t) {
    text = t;
    text = text.replaceAll(",", " ");
    text = text.replaceAll(";", " ");
    var values = text.split(" ");
    values.removeWhere((f) {
      return f.length == 0;
    });
    if(values.length > 0) {
      x = double.parse(values[0]);
    } else {
      x = 0;
    }
    if(values.length > 1) {
      y = double.parse(values[1]);
    } else {
      y = 0;
    }
    if(values.length > 2) {
      angle = double.parse(values[2]);
    } else {
      angle = 0;
    }
  }
}


class OneHmdPosition extends IvrStatefulWidget<HmdPosition> {

  String caption;
  String value;
  Function callback;


  OneHmdPosition(this.caption, this.value, this.callback, [HmdPosition d]) : super(data:d);

  @override
  OneHmdPositionState createState() => OneHmdPositionState();
}

class OneHmdPositionState extends IvrWidgetState<OneHmdPosition> {

  TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {

    if(ctrl == null) {
      ctrl = TextEditingController(text: '${widget.value}');
    }

    return Row(
      children: <Widget>[
        Text('${widget.caption}'),
        Flexible(
          child:
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
//              labelText: '服务器IP',
            ),
            onSubmitted: (v) {
              widget.callback(v);
            },
            autofocus: false,
          ),
        ),

      ],
    );
  }
}

class TestGameviewport extends IvrStatefulWidget<IvrData> {
  TestGameviewport([IvrData d]) : super(data:d);

  @override
  TestGameviewportState createState() => TestGameviewportState();
}

class TestGameviewportState extends IvrWidgetState<TestGameviewport> {

  Widget getTextField(String caption, double v, Function func) {
    return Row(
      children: <Widget>[
        Text('$caption'),
        Flexible(
          child:
          TextField(
            controller: TextEditingController(text: '$v'),
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
//              labelText: '服务器IP',
            ),
            onSubmitted: (v) {
              func(v);
            },
            autofocus: false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    var data = widget.data;
    if(data == null) {
      return Text('invalide data. [${this.runtimeType.toString()}]');
    }

    MyGameTest mygame = getMyGameTest();

    var list = List<Widget>();
    mygame.testData.forEach((f) {
      list.add(OneHmdPosition('输入(x y angle)', f.text, (v) {
        f.setText(v);
      }));
    });

    // 缩放系数
    list.add(OneHmdPosition('offsetX', mygame.offsetX.toStringAsFixed(2), (v) {
      mygame.offsetX = double.parse(v);
    }));
    list.add(OneHmdPosition('offsetY', mygame.offsetY.toStringAsFixed(2), (v) {
      mygame.offsetY = double.parse(v);
    }));
    list.add(OneHmdPosition('scaleX', mygame.scaleX.toStringAsFixed(2), (v) {
      mygame.scaleX = double.parse(v);
    }));
    list.add(OneHmdPosition('scaleY', mygame.scaleY.toStringAsFixed(2), (v) {
      mygame.scaleY = double.parse(v);
    }));
    list.add(OneHmdPosition('scaleAngle', mygame.scaleAngle.toStringAsFixed(2), (v) {
      mygame.scaleAngle = double.parse(v);
    }));
    list.add(OneHmdPosition('offsetAngle', mygame.offsetAngle.toStringAsFixed(2), (v) {
      mygame.offsetAngle = double.parse(v);
    }));
    list.add(CheckboxListTile(
      value: mygame.inverseX,
      title: Text("反转坐标"),
      onChanged: (b) {
        mygame.inverseX = b;
      },
    ));
    list.add(CheckboxListTile(
      value: mygame.inverseX2,
      title: Text("反转坐标2"),
      onChanged: (b) {
        mygame.inverseX2 = b;
      },
    ));


    list.add(mygame.widget);

    return Column(
      children: list,
    );
  }
}

class MyGameTest extends MyGame {

  final testData = new List<HmdPosition>();
  final testSprite = new List<SpriteComponent>();

  MyGameTest() : super() {
    testData.add(HmdPosition());
    testData.add(HmdPosition());
    testData.add(HmdPosition());
    testData.add(HmdPosition());

    testData[0].setText("-4.02 3.99 0");
    testData[1].setText("0 0 0");
    testData[2].setText("-6.01, 2.78 0");
    testData[3].setText("-4.02, 1.18 0");

    var colorKeys = ["c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8"];

    testData.asMap().forEach((i, f){
      var scale = 0.5;

      var headmount = SpriteComponent.rectangle(64 * scale, 64 * scale, "headmount.png");
      headmount
        .. anchor = Anchor.center
        .. x = size.width / 2
        .. y = size.height / 2;

      var redPaint = PaletteEntry(Color(0xFFFFFFFF)).paint;
      redPaint.colorFilter = ColorFilter.mode(Color(getDevicesColor(colorKeys[i])), BlendMode.srcATop);
      headmount.sprite.paint = redPaint;

      testSprite.add(headmount);
      add(headmount);
    });
  }

  @override
  void update(double t) {
    // TODO: implement update
    super.update(t);

    for(int i=0; i<testData.length; i++) {
      var v = gameToViewportValue(testData[i].x, testData[i].y, testData[i].angle);
      testSprite[i].x = v.first ?? 0;
      testSprite[i].y = v.second ?? 0;
      testSprite[i].angle = v.third ?? 0;
      // print('位置：(${testData[i].x},${testData[i].y},${testData[i].angle}) => (${v.first}, ${v.second}, ${v.third})');
    }
  }
}
MyGameTest myGameTest;
MyGameTest getMyGameTest() {
  if(myGameTest == null) {
    myGameTest = MyGameTest();
  }
  return myGameTest;
}