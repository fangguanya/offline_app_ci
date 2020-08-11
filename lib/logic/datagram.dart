import 'dart:io' as io;

// 协议回调处理
typedef void DatagramMessageResolver(String msg);

// UDP
class Datagram {
  io.RawDatagramSocket socket;
  String remoteIp;      // 服务器IP
  int remotePort;       // 服务器端口
  int localPort;        // 本地监听端口

  // 临时变量
  io.InternetAddress remoteAddress;

  // 消息处理
  var callbacks = new Map<String, List<DatagramMessageResolver>>();

  Datagram();

  bool isValid() {
    return socket != null;
  }

  /**
   * 内部API
   */
  void startListening() {
    print("UDP-startListening");
    try {
      socket.listen(onData, onError: onError, onDone: onDone);
    } on Exception catch (e) {
      print("startListening - exception raised $e");
    }
  }

  /**
   * 外部API
   */
  void on(String t, DatagramMessageResolver f) {
    if (f == null) return;
    t = t.toLowerCase();
    callbacks[t] ??= new List<DatagramMessageResolver>();
    callbacks[t].add(f);
  }

  void off(String t, [DatagramMessageResolver f]) {
    t = t.toLowerCase();
    var list = callbacks[t];
    if (list == null) return;
    if (f == null) {
      callbacks[t] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(String msg) {
    var subs = msg.split(":");
    if (subs.length > 1){
      var t = subs[0].toLowerCase();
      var arg = subs[1];
      var list = callbacks[t];
      if (list == null) return;
      List<DatagramMessageResolver> tmp = []..addAll(list);
      for (var i = 0; i < tmp.length; ++i) {
        tmp[i](arg);
      }
    }
  }

  void reconnect() {
    disconnect();
    if (remoteIp != null && remotePort != null) {
      connect(remoteIp, remotePort, localPort);
    }
  }

  void connect(String rip, int rport, int lport) async {
    if (socket != null && this.remoteIp == rip && this.remotePort == remotePort && this.localPort == lport) {
      print("已经链接到$rip:$rport");
      return;
    }
    if (rip == null || rip.length < 5){
      print('UDP-IP错误!:$rip}');
      return;
    }

    disconnect();
    try {
      this.remoteIp = rip;
      this.remoteAddress = new io.InternetAddress(this.remoteIp);
      this.remotePort = rport;
      this.localPort = lport;
      var localListenPort = this.localPort;
      if (lport == null){
        // 随机1个本地端口
        localListenPort = 0;
      }
      socket = await io.RawDatagramSocket.bind("0.0.0.0", localListenPort);
      print("本地UDP初始化成功:$localListenPort");
      startListening();
    } on Exception catch (e) {
      socket = null;
      print("connect-UDP:${this.remoteIp}:${this.remotePort} - exception raised $e");
    }
  }

  void sendMessage(String msg) {
    if (socket == null) {
      print("UDP:尝试发送协议,但是SOCKET还没有链接!");
      return;
    }
    if (msg == null || msg.length == 0){
      print("UDP:尝试发送长度为0的消息..");
      return;
    }
//    print('UDP 发送协议: $msg');
    socket.send(msg.codeUnits, remoteAddress, remotePort);
  }

  void disconnect() {
    if (socket != null) {
      socket.close();
      socket = null;
    }
  }

  void onData(io.RawSocketEvent e) {
//    print("socket-onData called");
    io.Datagram d = socket.receive();

    if (d == null || d.data.length == 0) {
      print("UDP-socket-onData - Error - 0 byte message");
      return;
    }

    // 进行协议数据得粘包处理
    String msg = new String.fromCharCodes(d.data).trim();
    emit(msg);
  }

  void onError(dynamic error) {
    disconnect();
    print("UDP-SOCKET:onError - 出错了,并自动调用了disconnect");
  }

  void onDone() {
    disconnect();
    print("UDP-SOCKET:onDone - 关闭了,并自动调用了disconnect");
  }
}