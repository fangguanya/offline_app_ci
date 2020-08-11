import 'dart:ui';

/**
 * Auth :   liubo
 * Date :   2019/9/22 23:03
 * Comment: 全局事件
 */

// https://book.flutterchina.club/chapter8/eventbus.html

//订阅者回调签名
typedef void EventCallback(arg);

class EventBus {
  //私有构造函数
  EventBus._internal();

  //保存单例
  static EventBus _singleton = new EventBus._internal();

  //工厂构造函数
  factory EventBus()=> _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _emap = new Map<Object, List<EventCallback>>();

  var _dispatcher = new EventDispatcher();

  //添加订阅者
  void on(eventName, EventCallback f) {
    _dispatcher.on(eventName, f);
  }

  //移除订阅者
  void off(eventName, [EventCallback f]) {
    _dispatcher.off(eventName, f);
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    _dispatcher.emit(eventName, arg);
  }

  void onUI(String id, VoidCallback callback) {
    on('ui:' + id, (arg) {
      callback();
    });
  }
  void offUI(String id) {
    off('ui' + id);
  }
  void refreshUI(String id) {
    if(id != null && id.length > 0) {
      emit('ui:' + id);
    }
  }
}

class EventDispatcher {
  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _emap = new Map<Object, List<EventCallback>>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  bool has(eventName) {
    var list = _emap[eventName];
    if (list == null) return false;

    return true;
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      try{
        list[i](arg);
      } catch(e) {
        print(e);
      }
    }
  }
}

//定义一个top-level变量，页面引入该文件后可以直接使用bus
var globalEvent = new EventBus();