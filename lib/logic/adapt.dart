/**
 * Auth :   liubo
 * Date :   2020/5/6 14:06
 * Comment: 手机屏幕适配：美术给的是像素，转化成flutter单位dp
 */

import 'package:flutter/material.dart';
import 'dart:ui';

class Adapt {
  static const int _standart = 1125;
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topbarH = mediaQuery.padding.top;
  static double _botbarH = mediaQuery.padding.bottom;
  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static var _ratio;
  static init(int number){
    int uiwidth = number is int ? number : _standart;
    _ratio = _width / uiwidth;
  }
  static px(number){
    if(!(_ratio is double || _ratio is int)){Adapt.init(_standart);}
    return 1.0 * (number * _ratio).floor();
  }
  static onepx(){
    return 1/_pixelRatio;
  }
  static screenW(){
    return _width;
  }
  static screenH(){
    return _height;
  }
  static padTopH(){
    return _topbarH;
  }
  static padBotH(){
    return _botbarH;
  }
}