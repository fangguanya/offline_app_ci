import 'dart:async';
import 'dart:math';

/**
 * Auth :   liubo
 * Date :   2019/10/31 14:44
 * Comment: 展示游戏内的情况：定位信息等
 */

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flame/text_config.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/anchor.dart';
import 'package:flame/palette.dart';
import 'package:kernel/text/serializer_combinators.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/device_state.dart';

import '../style.dart';

TextConfig regular = TextConfig(color: BasicPalette.white.color);
TextConfig tiny = regular.withFontSize(12.0);

class NewMyGameProfile {
  static Size _screenSize = Size(0, 0);

  static double width() {
    return min(_screenSize.width, _screenSize.height);
  }

  static load() async {
    final Size size = await Flame.util.initialDimensions();
    _screenSize = size;
    print("ScreenSize:$_screenSize");
  }
}

class NewMyGame extends BaseGame {

  // 将游戏中的数据映射到app中
  double scaleX = 1;
  double scaleY = 1;
  double offsetX = 1;
  double offsetY = 1;
  double offsetAngle = 90;
  double scaleAngle = -1;
  bool inverseX = false;
  bool inverseX2 = false;

  double hmdIconScale = 0.5;
  double weaponIconScale = 0.5;


  Size perfectSize;
  double perfectScale;

  TextComponent t1;
  SpriteComponent image1;

  final Map<String, SpriteComponent> hmdImages = new Map<String, SpriteComponent>();
  final Map<String, TextComponent> hmdTexts = new Map<String, TextComponent>();
  final Map<String, SpriteComponent> weaponImages = new Map<String, SpriteComponent>();

  NewMyGame({width = 0}) {

    // 背景图大小
    const bgWidth = 1242;
    const bgHeight = 1783;

    // 测试数据
    if(true) {
      var game3d = new List<Point<double>>();
      var view2d = new List<Point<double>>();

      game3d.add(Point<double>(-4.02, 3.99));
      game3d.add(Point<double>(-5.23, 3.99));
      game3d.add(Point<double>(-6.01, 2.78));
      game3d.add(Point<double>(-9.59, 3.99));
      game3d.add(Point<double>(-4.02, 1.18));
      game3d.add(Point<double>(0, 0));

      view2d.add(Point<double>(1108, 558));
      view2d.add(Point<double>(919, 558));
      view2d.add(Point<double>(798, 741));
      view2d.add(Point<double>(243, 558));
      view2d.add(Point<double>(1108, 990));
      view2d.add(Point<double>(1738, 1194));

      calcMatrix(game3d, view2d);
    }

    print("比例系数：($scaleX, $offsetX), ($scaleY, $offsetY)");

    // 左右两边留空20
    if(width == 0) {
      width = NewMyGameProfile.width() - 40;
    }
    var w = width;

    perfectScale = 0.5;
    if(w > 100) {
      perfectScale = w / bgWidth;
    }

    hmdIconScale = IvrPixel.px96 / 64;

    // size = Size(NewMyGameProfile.width(), NewMyGameProfile.width());
    perfectSize = Size(perfectScale * bgWidth, perfectScale * bgHeight);
    size = perfectSize;
    print("game size:$size");

    // todo. 改成json信息配置
    var scale = 0.5;
    if(size.width > 100) {
      scale = size.width / bgWidth;

      perfectScale = scale;
    }

    if(true) {
      var gameBg = SpriteComponent.rectangle(bgWidth * scale, bgHeight * scale, "assets/map.png");
      gameBg
        .. anchor = Anchor.center
        .. x = size.width / 2
        .. y = size.height / 2;
      add(gameBg);
    }

    var redPaint = PaletteEntry(Color(0xFFFFFFFF)).paint;
    redPaint.colorFilter = ColorFilter.mode(Color(0xFFFF0000), BlendMode.srcATop);

    var headmount = SpriteComponent.rectangle(64 * hmdIconScale, 64 * hmdIconScale, "assets/player1.png");//"headmount.png");
    headmount
      .. anchor = Anchor.center
      .. x = size.width / 2
      .. y = size.height / 2;
    //headmount.sprite.paint = redPaint;
    headmount.angle = toRadian(90);
    //add(headmount);

    var headId = TextComponent("1", config:TextConfig(fontSize: IvrPixel.px40));
    headId
        ..x =size.width / 2
      ..y =size.height / 2
      ..anchor = Anchor.center
      ..text = ("1");
    //add(headId);

    var weapon = SpriteComponent.rectangle(32 * 0.5, 32 * 0.5, "gun.png");
    weapon
      .. anchor = Anchor.center
      .. x = size.width / 2 - 100
      .. y = size.height / 2;
    weapon.sprite.paint = redPaint;
    //add(weapon);



    t1 = TextComponent('Hello, Flame', config: regular)
      ..anchor = Anchor.topCenter
      ..x = size.width / 2
      ..y = 0;
    //add(t1);

    image1 = SpriteComponent.rectangle(32, 32, "yum.png");
    image1
      .. anchor = Anchor.center
      .. x = size.width / 2
      .. y = size.height / 3;
    //add(image1);

//    add(TextComponent('center', config: tiny)
//      ..anchor = Anchor.center
//      ..x = size.width / 2
//      ..y = size.height / 2);
//
//    add(TextComponent('bottomRight', config: tiny)
//      ..anchor = Anchor.bottomRight
//      ..x = size.width
//      ..y = size.height-50);
  }

  @override
  void render(Canvas canvas) {

    // 绘制背景
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint() .. color = Colors.transparent);


    super.render(canvas);
  }

  @override
  Widget get widget {
    var w = super.widget;
    var root = Container(
      //padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
      child: w,
      width: perfectSize.width,
      height: perfectSize.height,
    );
    return root;
  }

  @override
  void update(double t) {
    super.update(t);

    t1.angle += 0.1;
    image1.angle += 0.1;

    weaponImages.forEach((k, v) {
      var t = getWeaponTransform(k);
      v.x = t.first;
      v.y = t.second;
      v.angle = t.third;
    });

    hmdImages.forEach((k, v) {
      var t = getHmdTransform(k);
      v.x = t.first;
      v.y = t.second;
      v.angle = t.third;
    });
    hmdTexts.forEach((k, v) {
      var t = getHmdTransform(k);
      v.x = t.first;
      v.y = t.second;
      v.angle = t.third;
    });
  }

  int getDevicesColor(String id) {

    final Map<String, int> devicesColor = {
      "c1":0xFFFF0000,
      "c2":0xFF00FF00,
      "c3":0xFFFF00FF,
      "c4":0xFF0000FF,
      "c5":0xFF00FFFF,
      "c6":0xFFF00000,
      "c7":0xFFF0F0F0,
      "c8":0xFF0F0F0F,
    };

    if(!devicesColor.containsKey(id)) {
      return 0xFFFFFFFF;
    }

    return devicesColor[id];
  }

  String getDevicesImage(String id) {

    final Map<String, String> devicesColor = {
      "c1":"assets/player1.png",
      "c2":"assets/player1.png",
      "c3":"assets/player1.png",
      "c4":"assets/player1.png",
      "c5":"assets/player2.png",
      "c6":"assets/player2.png",
      "c7":"assets/player2.png",
      "c8":"assets/player2.png",
    };

    if(!devicesColor.containsKey(id)) {
      return "assets/player1.png";
    }

    return devicesColor[id];
  }

  String getDevicesCaption(String id) {

    final Map<String, String> devicesColor = {
      "c1":"1",
      "c2":"2",
      "c3":"3",
      "c4":"4",
      "c5":"5",
      "c6":"6",
      "c7":"7",
      "c8":"8",
    };

    if(!devicesColor.containsKey(id)) {
      return "assets/player1.png";
    }

    return devicesColor[id];
  }

  setGameDataUseList(Map<String, GameClientStateData> clients) {

    if(clients.length != hmdImages.length) {

      hmdImages.forEach((k, v) {
        components.remove(v);
      });
      hmdTexts.forEach((k, v) {
        components.remove(v);
      });
      weaponImages.forEach((k, v) {
        components.remove(v);
      });

      hmdImages.clear();
      weaponImages.clear();
      hmdTexts.clear();

      clients.forEach((k, v) {

        var color = getDevicesColor(k);

        var redPaint = PaletteEntry(Colors.white).paint;
        redPaint.colorFilter = ColorFilter.mode(Color(color), BlendMode.srcATop);

//        weaponImages[k] = SpriteComponent.rectangle(32 * weaponIconScale, 32 * weaponIconScale, "gun.png");
//        weaponImages[k].anchor = Anchor.center;
//        weaponImages[k].sprite.paint = redPaint;
//        add(weaponImages[k]);

        hmdImages[k] = SpriteComponent.rectangle(64 * hmdIconScale, 64 * hmdIconScale, getDevicesImage(k));
        hmdImages[k].anchor = Anchor.center;
        //hmdImages[k].sprite.paint = redPaint;
        add(hmdImages[k]);

        hmdTexts[k] = TextComponent((getDevicesCaption(k)), config:TextConfig(fontSize: IvrPixel.px40));
        hmdTexts[k]
//          ..x =size.width / 2
//          ..y =size.height / 2
          ..anchor = Anchor.center;
        add(hmdTexts[k]);
      });
    }
  }

  void setGameData(OneGameData gameinfo) {
    if(gameinfo == null) {
      return;
    }

    setGameDataUseList(gameinfo.clients);
  }

  static Tuple3<double, double, double> getDefaultDevicePosition() {
    return Tuple3<double, double, double>(-1000, -1000, 0);
  }

  Tuple3<double, double, double> gameToViewportValue(double x, double y, double angle) {

    x = x ?? 0;
    y = y ?? 0;
    angle = angle ?? 0;

    if(inverseX) {
      var tmp = x;
      x = y;
      y = tmp;
    }

    if(true) {
      x *= scaleX;
      y *= scaleY;

      x += offsetX;
      y += offsetY;
    }

    angle = toRadian(angle * scaleAngle + offsetAngle);

    // 默认情况下，3d游戏中的x轴对应gameviewport的y轴
    // 3d->2d:x=>y, z=>x
    if(!inverseX2) {
      var tmp = x;
      x = y;
      y = tmp;
    }

    return Tuple3<double, double, double>(perfectScale*x, perfectScale*y, angle);
  }

  Tuple3<double, double, double> transformValue(int id) {
    var data = Application.dataCenter;
    if(data.devices.containsKey(id) && data.devices[id] != null) {
      var d = data.devices[id];
      if(d != null) {
        return gameToViewportValue(d.hybridPosition.x, d.hybridPosition.z, d.hybridRotation.yaw);
      }
    }

    return getDefaultDevicePosition();
  }

  Tuple3<double, double, double> getHmdTransform(String deviceId) {
    var data = Application.dataCenter;
    if(data.hmdIdx.containsKey(deviceId)) {
      var id = data.hmdIdx[deviceId];
      return transformValue(id);
    }

    return getDefaultDevicePosition();
  }
  Tuple3<double, double, double> getWeaponTransform(String deviceId) {
    var data = Application.dataCenter;
    if(data.weaponIdx.containsKey(deviceId)) {
      var id = data.weaponIdx[deviceId];
      return transformValue(id);
    }

    return getDefaultDevicePosition();
  }

  static double toRadian(double angle) {
    angle = angle ?? 0;
    return angle * 3.14 / 180;
  }

  calcMatrix(List<Point<double>> g3d, List<Point<double>> v2d) {
    if(g3d == null || v2d == null || g3d.length != v2d.length) {
      print('无法计算matrix，数据不正常');
      return;
    }


    var calcMatrix2 = (x1, y1, x2, y2)  {
      if(x2 - x1 < 0.001) {
        return null;
      }
      var a = (y2 - y1) / (x2- x1);
      var b = y1 - a * x1;
      return Point<double>(a, b);
    };

    var xTotal = List<Point<double>>(), yTotal = List<Point<double>>();
    for(int i=0; i<g3d.length; i++) {
      for(int j=i+1; j<v2d.length; j++) {
        xTotal.add(calcMatrix2(g3d[i].x, v2d[i].x, g3d[j].x, v2d[j].x));
        yTotal.add(calcMatrix2(g3d[i].y, v2d[i].y, g3d[j].y, v2d[j].y));
      }
    }
    var calc1 = (List<Point> listValue) {
      var v1 = Point<double>(0, 0);
      listValue.removeWhere((e){
        return e == null;
      });
      listValue.forEach((f) {
        v1 += f;
      });
      return Point<double>( v1.x / listValue.length, v1.y/ listValue.length);
    };

    var v1 = calc1(xTotal);
    var v2 = calc1(yTotal);

    scaleX = v1.x; offsetX = v1.y;
    scaleY = v2.x; offsetY = v2.y;
  }
}
