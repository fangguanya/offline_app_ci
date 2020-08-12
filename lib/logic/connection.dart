import 'dart:async';
import 'dart:convert'; // JSON库
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqttsvr;
import 'package:operator_controller/models/config_data.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/device/rotator.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/models/protocol/game_config.dart';
import 'package:operator_controller/models/protocol/game_state.dart';
import 'package:operator_controller/models/protocol/play_game.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/logic/application.dart';
import 'dart:math';

import 'constants.dart';

// 协议回调对象
typedef void MessageResolver(String topic, Map<String, dynamic> data);

// 与后台有关的数据等
class Connection {
  EventDispatcher _dispatcher = new EventDispatcher();

  String broker = defaultIp;
  int port = 1883;
  String username = '';
  String passwd = '';
  String clientIdentifier = 'operator';
  int connectCounter = 0;

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  // 注册的回调记录一下
  List<String> subscribers = new List<String>();

  // 回调映射 : 注意,部分协议发送时,增加了/id的处理
  var callbacks = new Map<String, List<MessageResolver>>();
  void on(topic, MessageResolver f) {
    if (topic == null || f == null) return;
    callbacks[topic] ??= new List<MessageResolver>();
    callbacks[topic].add(f);

    // 如果未向底层注册,则注册一下
    _subscribe(topic);
  }

  void off(topic, [MessageResolver f]) {
    var list = callbacks[topic];
    if (topic == null || list == null) return;
    if (f == null) {
      callbacks[topic] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(String topic, Map<String, dynamic> arg) {
    var list = callbacks[topic];
    if (list == null) return;
    List<MessageResolver> tmp = []..addAll(list);
    for (var i = 0; i < tmp.length; ++i) {
      tmp[i](topic, arg);
    }
  }

  void init() {
    _dispatcher.on(Protocol.TopicGameState, onTopicGameState);
    _dispatcher.on(Protocol.TopicGameAllConfig, onTopicGameAllConfig);
  }

  // 显示的图标
  IconData connectionStateIcon;
  IconData getStateIcon() {
    switch (client?.connectionState) {
      case mqtt.MqttConnectionState.connected:
        connectionStateIcon = Icons.cloud_done;
        break;
      case mqtt.MqttConnectionState.disconnected:
        connectionStateIcon = Icons.cloud_off;
        break;
      case mqtt.MqttConnectionState.connecting:
        connectionStateIcon = Icons.cloud_upload;
        break;
      case mqtt.MqttConnectionState.disconnecting:
        connectionStateIcon = Icons.cloud_download;
        break;
      case mqtt.MqttConnectionState.faulted:
        connectionStateIcon = Icons.error;
        break;
      default:
        connectionStateIcon = Icons.cloud_off;
    }
    return connectionStateIcon;
  }

  void reconnect() {
    disconnect();
    connect();
  }

  bool isConnected() {
    return client != null &&
        client.connectionStatus != null &&
        client.connectionStatus.state == mqtt.MqttConnectionState.connected;
  }

  // 连接/断开等等
  void connect() async {
    if (client?.connectionState == mqtt.MqttConnectionState.connected ||
        client?.connectionState == mqtt.MqttConnectionState.connecting) {
      return;
    }
    if (client != null) {
      disconnect();
    }

    if (broker.contains(":")) {
      var ipaddr = broker.split(":");
      broker = ipaddr[0];
      port = int.parse(ipaddr[1]);
    } else {
      port = 1883;
    }

    client = mqttsvr.MqttServerClient.withPort(broker, '', port);
    client.logging(on: false);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;

    // 注册基础的消息
    _subscribe(Protocol.TopicsOperateWorkerConfigs);
    _subscribe(Protocol.TopicsOperateWorkerConfig);
    _subscribe(Protocol.TopicGameState);
    _subscribe(Protocol.TopicGameAllConfig);

    // 测试消息
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(
            clientIdentifier + Random().nextInt(500000).toString())
        .startClean()
        .keepAliveFor(30)
        .withWillTopic('test/test')
        .withWillMessage('lamhx message test')
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('client connecting....');
    client.connectionMessage = connMess;

    connectCounter++;
    int cnt = connectCounter;

    try {
      while (client.connectionState != mqtt.MqttConnectionState.connected) {
        await client.connect(username, passwd);
        await new Future.delayed(new Duration(milliseconds: 3000));
      }
      print('连接成功：' + broker);
    } catch (e) {
      if (cnt == connectCounter) {
        print(e);
        disconnect();
      }
    }
  }

  void disconnect() {
    if (client == null) {
      return;
    }

    client.disconnect();
    _onDisconnected();
  }

  // 发送包
  void sendMessage(String p, String j) {
    if (!isConnected()){
      return;
    }
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();
    builder.addString(j);
    client.publishMessage(
      p,
      mqtt.MqttQos.exactlyOnce,
      builder.payload,
//      retain: _retainValue,
    );
  }

  // 内部的回调API
  void _subscribe(String s) {
    bool exist = false;
    for (int i = 0; i < subscribers.length; ++i) {
      if (subscribers[i] == s) {
        exist = true;
      }
    }
    if (!exist) {
      subscribers.add(s);
    }
    if (client != null &&
        client.connectionState == mqtt.MqttConnectionState.connected) {
      client.subscribe(s, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _reSubscribe() {
    if (client == null) {
      return;
    }
    for (int i = 0; i < subscribers.length; ++i) {
      client.subscribe(subscribers[i], mqtt.MqttQos.exactlyOnce);
    }
  }

  void _onConnected() {
    connectionState = client.connectionState;
    print("client connected");
    _reSubscribe();

    // 请求数据
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();
    builder.addString("");
    client.publishMessage(Protocol.TopicsOperateWorkerAppLaunch,
        mqtt.MqttQos.exactlyOnce, builder.payload);
    client.publishMessage(Protocol.TopicsOperateConfigGameRemoteGet,
        mqtt.MqttQos.exactlyOnce, builder.payload);

    client.updates.listen(_onMessage);
    connectionState = client.connectionState;
  }

  void _onDisconnected() {
    connectionState = client.connectionState;
    print('client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
//    print('receive message count=<${event.length}>');

    // 处理消息
    for (int i = 0; i < event.length; ++i) {
      mqtt.MqttReceivedMessage msg = event[i];
      final mqtt.MqttPublishMessage recMess =
          msg.payload as mqtt.MqttPublishMessage;

      final String message = utf8.decode(recMess.payload.message);
      final String topic = msg.topic;

      Map<String, dynamic> list = json.decode(message);
      emit(topic, list);

      if (_dispatcher.has(topic)) {
        try {
          _dispatcher.emit(topic, message);
        } catch (e) {
          print(e);
        }
        continue;
      }
    }
  }

  void onTopicGameAllConfig(arg) {
    OneGameListConfig msg;
    try {
      msg = OneGameListConfig.fromJson(json.decode(arg));
    } catch (e) {
      print(e);
      return;
    }

    msg.hmdIdx.forEach((k, v) {
      Application.dataCenter.hmdIdx[k] = v.round();
    });
    msg.weaponIdx.forEach((k, v) {
      Application.dataCenter.weaponIdx[k] = v.round();
    });
  }

  // 协议处理
  void onTopicGameState(arg) {
    GameStateProtocol msg;
    try {
      msg = GameStateProtocol.fromJson(json.decode(arg));
    } catch (e) {
      print(e);
      return;
    }

    msg.monitorPid.forEach((k, v) {
      if (msg.monitorPidIdx.containsKey(k)) {
        Application.dataCenter.monitorPid[k] =
            MapEntry<int, int>(v, msg.monitorPidIdx[k]);
      }
    });
    msg.hmdIdx.forEach((k, v) {
      Application.dataCenter.hmdIdx[k] = v;
    });
    msg.weaponIdx.forEach((k, v) {
      Application.dataCenter.weaponIdx[k] = v;
    });

    var seatStatus = Application.dataCenter.seatStatus;
    seatStatus.clear();
    msg.seatStatus.forEach((k, v) {
      seatStatus[k] = v;
    });

    var gameDatas = Application.dataCenter.gameDatas;
    // 根据Cfg信息，构建所配置的电脑信息
    bool dirty = false;
    for (var d in msg.datas) {
      var sid = d.cfg.gameServerId;

      OneGameData onegame;
      if (!gameDatas.containsKey(sid)) {
        onegame = OneGameData(sid);
        gameDatas[sid] = onegame;
        dirty = true;
      } else {
        onegame = gameDatas[sid];
      }

      onegame.cfg = d.cfg;
      onegame.desiredDeviceList = d.desiredDeviceList;
      onegame.gameReady = d.gameReady != null && d.gameReady > 0 ? true : false;
      onegame.setGameFlag(d.gameFlag);
      onegame.lastRepTime = DateTime.now().millisecondsSinceEpoch;
      onegame.seatCount = d.seatCount;

      for (var cid in d.cfg.clientIdList) {
        if (!onegame.clients.containsKey(cid)) {
          dirty = true;
          onegame.clients[cid] = GameClientStateData(id: cid, serverId: sid);
        }
      }
    }

    if (dirty) {
      globalEvent.refreshUI(UIID.UI_AllDevices);
    }

    // 收到所有的座椅状态
    for (var d in msg.datas) {
      var sid = d.cfg.gameServerId;
      OneGameData onegame;
      if (!gameDatas.containsKey(sid)) {
        continue;
      } else {
        onegame = gameDatas[sid];
      }

      var s = d.allDeviceMetaList[sid];
      if (s != null) {
        onegame.gameServer.id = sid;
        onegame.gameServer.hasProcess = getProcessOnline(sid);
        onegame.gameServer.online =
            s.isOnlineFlag ?? gameDatas[sid].gameServer.online;
        onegame.gameServer.step = s.progress ?? gameDatas[sid].gameServer.step;
        onegame.gameServer.diff = s.diff ?? gameDatas[sid].gameServer.diff;
      } else {
        onegame.gameServer.online = false;
        onegame.gameServer.hasProcess = getProcessOnline(sid);
        onegame.gameServer.step = 0;
        onegame.gameServer.diff = 0;
      }

      for (var cid in d.cfg.clientIdList) {
        GameClientStateData cdata;
        if (!onegame.clients.containsKey(cid)) {
          continue;
        } else {
          cdata = onegame.clients[cid];
        }

        if (!d.allDeviceMetaList.containsKey(cid)) {
          cdata.hasProcess = getProcessOnline(cid);
          cdata.online = false;
          cdata.hasPlayerId = false;
          cdata.blue = false;
          cdata.height = false;
          cdata.locator = false;
          cdata.step = 0;
          cdata.using = false;
          cdata.trackerBattery = -1;

          cdata.count = 0;
          cdata.percent = 0;
          cdata.adjusting = false;
          cdata.losingTracking = false;
          continue;
        }

        var c = d.allDeviceMetaList[cid];
        assert(cdata != null);
        if (c != null && cdata != null) {
          cdata.hasProcess = getProcessOnline(cid);
          cdata.online = c.isOnlineFlag ?? cdata.online;
          cdata.hasPlayerId = c.playerIdDone ?? cdata.hasPlayerId;
          cdata.blue = c.blueRoomDone ?? cdata.blue;
          cdata.height = c.adjustHeightDone ?? cdata.height;
          cdata.locator = false ?? cdata.locator;
          cdata.step = c.progress ?? cdata.step;
          cdata.using = true;
          cdata.trackerBattery = Application.dataCenter.getTrackerBattery(cid);
          cdata.avatar = c.avatar;

          cdata.count = c.count;
          cdata.percent = c.percent;
          cdata.adjusting = c.adjusting;
          cdata.losingTracking = c.losingTracking;
        }
      }
    }
    globalEvent.refreshUI(UIID.UI_AllDevices);
  }

  void addClient(String cid) {
    _appendClient(cid, Constants.AppendClientOpAdd);
  }

  void eraseClient(String cid) {
    _appendClient(cid, Constants.AppendClientOpDelete);
  }

  void _appendClient(String cid, int op) {
    var sid = Application.dataCenter.getServerIdByClientId(cid);
    var clientid = [cid];
    appendClient(sid, clientid, op);
  }

  void appendClient(String sid, List<String> clientid, int op) {
    if (sid == null || sid == '' || clientid == null || clientid.length == 0) {
      return;
    }

    var msg = PlayGameInfo();
    msg.clientIdList = clientid;
    msg.serverId = sid;
    msg.flag = op;

    sendMessage(Protocol.TopicGameAppendClient, playGameInfoToJson(msg));
  }

  void openGameClient2(String deviceId) {
    if (Application.dataCenter.monitorPid.containsKey(deviceId)) {
      var id = Application.dataCenter.monitorPid[deviceId];
      var monitor = Application.dataCenter
          .getMonitor(id.key); //Application.connection.GetWorker(id);
      if (monitor != null && monitor.id != null && monitor.id == id.key) {
        if (Application.dataCenter.settingData.data.autoCloseSteamVR) {
          monitor.runWithName("vrmonitor.exe", ExecutionType.RESTART);
          print('操作设备：[${id.key}][自动关闭vrmonitor.exe]');
        }
      }
    }

    Future.delayed(Duration(seconds: 5), (){
      var msg = OperateDeviceMsg();
      msg.deviceId = deviceId;
      msg.operate = Constants.RunProcess;
      msg.flag = 0;

      sendMessage(Protocol.TopicGameOperateDevice, operateDeviceMsgToJson(msg));
      print('延时5s执行');
    });
  }

  void closeGameClient2(String deviceId, bool force) {
    var msg = OperateDeviceMsg();
    msg.deviceId = deviceId;
    msg.operate = Constants.KillProcess;
    msg.flag = force ? Constants.FlagForceKill : 0;

    sendMessage(Protocol.TopicGameOperateDevice, operateDeviceMsgToJson(msg));
  }

  void openGame(String sid, List<String> clientIdList) {
    var msg = PlayGameInfo();
    msg.clientIdList = clientIdList;
    msg.serverId = sid;
    msg.flag = Constants.GameFlagReadyGo;

    var rs = Application.dataCenter.getHardwares(DeviceType.ROTATOR);
    if (rs.length > 0) {
      (rs[0] as Rotator).turnOn("");
    }
    clientIdList.forEach((deviceId) {
      if (Application.dataCenter.monitorPid.containsKey(deviceId)) {
        var id = Application.dataCenter.monitorPid[deviceId];
        var monitor = Application.dataCenter
            .getMonitor(id.key); //Application.connection.GetWorker(id);
        if (monitor != null && monitor.id != null && monitor.id == id.key) {
          if (Application.dataCenter.settingData.data.autoCloseSteamVR) {
            monitor.runWithName("vrmonitor.exe", ExecutionType.RESTART);
            print('操作设备：[${id.key}][自动关闭vrmonitor.exe]');
          }
        }
      }
    });
    Future.delayed(Duration(seconds: 5), (){
      sendMessage(Protocol.TopicGameSetGameFlag, playGameInfoToJson(msg));
      print('延时5s执行');
    });

    // TODO:目前只有末日营救(之后要在界面中手动选取)
    Application.dataCenter.sharing.selectGame(sid, "robot");
  }

  void readyGame(String sid) {
    var msg = PlayGameInfo();
    msg.serverId = sid;
    msg.flag = Constants.GameFlagGaming;
    msg.clientIdList = List<String>();

    // 确保进程启动之后,主动同步一次数据!
    Application.dataCenter.sharing.getOrCreateRoom(sid);

    sendMessage(Protocol.TopicGameSetGameFlag, playGameInfoToJson(msg));
  }

  void closeGame(String sid) {
    var msg = PlayGameInfo();
    msg.serverId = sid;
    msg.flag = Constants.GameFlagCloseGame;
    msg.clientIdList = List<String>();

    sendMessage(Protocol.TopicGameSetGameFlag, playGameInfoToJson(msg));

    // 同时确保录屏数据保存以下
    Application.dataCenter.sharing.finishRoom(sid);
  }

  void openGameClient(String deviceId) {
    openGameClient2(deviceId);
//    _runDeviceProcess(deviceId, Constants.RunProcess);
  }

  void closeGameClient(String deviceId) {
    closeGameClient2(deviceId, false);
    //_runDeviceProcess(deviceId, Constants.KillProcess);
  }

  // 启动设备进程。
  void _runDeviceProcess(String deviceId, int a) {
    if (!Application.dataCenter.monitorPid.containsKey(deviceId)) {
      print('无法找到设备：$deviceId');
      return;
    }

    var id = Application.dataCenter.monitorPid[deviceId];
    // 进程配置文件可以配置多个，但是第0个表示设备的。
    _runWorkerRunner(id.key, id.value, a);
  }

  void _runWorkerRunner(int id, int index, int a) {
    assert(a == 1 || a == 2 || a == 3);

    var monitor = Application.dataCenter
        .getMonitor(id); //Application.connection.GetWorker(id);
    if (monitor == null || monitor.id == null || monitor.id != id) {
      print('无法找到设备信息：$id');
      return;
    }

    print('操作设备：[$id,$index][$a]');
    monitor.runWithIndex(index, a);
  }

  bool getProcessOnline(String deviceId) {
    if (!Application.dataCenter.monitorPid.containsKey(deviceId)) {
      return false;
    }

    var id = Application.dataCenter.monitorPid[deviceId];
    var monitor = Application.dataCenter
        .getMonitor(id.key); //Application.connection.GetWorker(id);
    if (monitor == null || monitor.id == null || monitor.id != id.key) {
      return false;
    }

    return monitor.isRunningWithIndex(id.value);
  }

  void changeAvatar(String sid, String id, int avatar) {
    var msg = AvatarInfo();
    msg.clientId = id;
    msg.avatarId = avatar;

    int index = 0;
    if (id == "c1" || id == "c5"){
      index = 0;
    }
    else if (id == "c2" || id == "c6"){
      index = 1;
    }
    else if (id == "c3" || id == "c7"){
      index = 2;
    }
    else if (id == "c4" || id == "c8"){
      index = 3;
    }

    // 选择性别了
    Application.dataCenter.sharing.setPlayerGender(sid, index, Constants.getAvatarGender(avatar));
    
    sendMessage(Protocol.TopicGameChangeAvatar, avatarInfoToJson(msg));
  }

  void adjustPosition(String id, bool b) {
    var msg = AdjustPositionInfo();
    msg.clientId = id;
    msg.adjust = b ? 1 : 0;

    sendMessage(Protocol.TopicGameAdjust, adjustPositionInfoToJson(msg));
  }

  void modifyDifficulty(String id, int diff) {
    var msg = ModifyDifficultyInfo();
    msg.serverId = id;
    msg.diff = diff;

    sendMessage(Protocol.TopicGameModifyDiff, modifyDifficultyInfoToJson(msg));
  }
}
