import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:operator_controller/logic/byte_buffer.dart';
import 'package:typed_data/typed_buffers.dart';

// 协议回调处理
typedef void LinkMessageResolver(int t, Map<String, dynamic> data);

// 长连接,需要自动重新链接,并且在收到'remote'服务器配置后,重新链接
class Link {
  Socket socket;
  String ip;
  int port;
  ByteBuffer stream;
  bool autoReconnect;

  // 消息处理
  var callbacks = new Map<int, List<LinkMessageResolver>>();

  Link(this.autoReconnect);

  bool isValid() {
    return socket != null;
  }

  /**
   * 内部API
   */
  void startListening() {
    print("startListening");
    try {
      socket.listen(onData, onError: onError, onDone: onDone);
    } on Exception catch (e) {
      print("startListening - exception raised $e");
    }
  }

  /**
   * 外部API
   */
  void on(int t, LinkMessageResolver f) {
    if (f == null) return;
    callbacks[t] ??= new List<LinkMessageResolver>();
    callbacks[t].add(f);
  }

  void off(int t, [LinkMessageResolver f]) {
    var list = callbacks[t];
    if (list == null) return;
    if (f == null) {
      callbacks[t] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(int t, Map<String, dynamic> arg) {
    var list = callbacks[t];
    if (list == null) return;
    List<LinkMessageResolver> tmp = []..addAll(list);
    for (var i = 0; i < tmp.length; ++i) {
      tmp[i](t, arg);
    }
  }

  void reconnect() {
    disconnect();
    if (ip != null && port != null) {
      connect(ip, port);
    }
  }

  void connect(String ip, int port) async {
    if (socket != null && this.ip == ip && this.port == port) {
      print("已经链接到$ip:$port");
      return;
    }

    this.ip = ip;
    this.port = port;
    disconnect();
    try {
      Socket.connect(this.ip, this.port).then((dynamic c) {
        socket = c;
        socket.setOption(SocketOption.tcpNoDelay, true);
        print("成功链接到了${this.ip}:${this.port}");
        stream = ByteBuffer(Uint8Buffer());
        startListening();
      }).catchError((dynamic e) {
        socket = null;
        disconnect();
        print("链接到:${this.ip}:${this.port}失败了...catchError $e");
      });
    } on Exception catch (e) {
      socket = null;
      print("connect:${this.ip}:${this.port} - exception raised $e");
    }
  }

  void sendMessage<T>(int t, T msg) {
    if (socket == null) {
//      print("尝试发送协议,但是SOCKET还没有链接!");
      return;
    }
    ByteBuffer buf = ByteBuffer(Uint8Buffer());
    buf.writeShort(t);
    var s1 = Map<String, dynamic>();
    s1["value0"] = msg;
    buf.writeString(json.encode(s1));
    buf.reset();

    final Uint8Buffer tmp = buf.read(buf.length);
    socket.add(tmp.toList());
  }

  void disconnect() {
    if (socket != null) {
      socket.close();
      socket = null;
    }
  }

  void onData(List<int> data) {
//    print("socket-onData called");
    if (data.length == 0) {
      print("socket-onData - Error - 0 byte message");
      return;
    }

    // 进行协议数据得粘包处理
    stream.addAll(data);

    // 8子节:4子节协议长度,4子节协议id
    // 若干子节得协议内容体(json)
    while (stream.length >= 8) {
      final int type = stream.readShort();
      final int len = stream.readShort();
      if (stream.remain >= len) {
        // 得到了字符串数据!
        stream.descend = 2; // 后退2个子节,方便内部读取length
        final String message = stream.readString();
        Map<String, dynamic> list = json.decode(message);
        var l = list["value0"];
        emit(type, l as Map<String, dynamic>);
        stream.shrink();
      } else {
        stream.reset();
        break;
      }
    }
  }

  void onError(dynamic error) {
    disconnect();
    print("socket:onError - 出错了,并自动调用了disconnect");
    if (autoReconnect) {
      print("自动重连!");
      connect(this.ip, this.port);
    }
  }

  void onDone() {
    disconnect();
    print("socket:onDone - 关闭了,并自动调用了disconnect");
  }
}
