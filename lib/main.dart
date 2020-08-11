import 'dart:async';

import 'package:flutter/material.dart';
import 'package:operator_controller/logic/link.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/panel/calibration/section_calibration.dart';
import 'package:operator_controller/panel/device/allhardware.dart';
import 'package:operator_controller/panel/device/allpc.dart';
import 'package:operator_controller/panel/hardware/section_hardware.dart';
import 'package:operator_controller/panel/battle/battle.dart';
import 'package:operator_controller/panel/setting.dart';
import 'package:operator_controller/panel/onegame/one_game.dart';
import 'package:operator_controller/panel/sharing/video_record.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/connection.dart';
import 'package:operator_controller/logic/datagram.dart';
import 'package:operator_controller/panel/style.dart';
import 'package:reflectable/reflectable.dart';
import 'package:operator_controller/panel/sharing/screen_util.dart';
import 'logic/constants.dart';
import 'main.reflectable.dart';
import 'models/core/event_bus.dart';
import 'panel/battle/widget.dart';

void main() async {
  // 初始化全局变量
  initializeReflectable();
  final connection = Connection();
  connection.init();
  Application.connection = connection;

  final datagramlink = Datagram();
  Application.hardwareYDL = datagramlink;

  final link1 = Link(true);
  Application.transmit = link1;
  final link2 = Link(true);
  Application.tracker = link2;

  Application.dataCenter = DataCenter();
  Application.dataCenter.register();

  // 加载持久化数据
  print('加载数据...');
  await Application.dataCenter.load();

  Application.dataCenter.test();
  Application.dataCenter.startJob();

  Application.connection.connect();

  ScreenUtil.init();

  // 随意等1秒
  await Future.delayed(const Duration(seconds: 1));

  // 展示页面
  print('展示第一个页面...');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  PageController _pageController;
  int _page = 0;
  String titleBar = '运营';
  IvrRotator2 refRot2;

  MyAppState() {
    Application.main = this;
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context;
    void navigationTapped(int page) {
      Application.newsetting = false;
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    void onPageChanged(int page) {
      setState(() {
        this._page = page;
      });
    }

    bool newVersion = Application.isNew();

    var items = new List<BottomNavigationBarItem>();
    var panels = new List<Widget>();

    if (newVersion) {
      items.addAll([
        BottomNavigationBarItem(
          icon: Image(
            image: IvrAssets.getPng(
                _page == 0 ? "btn_process_selected" : "btn_process_normal"),
            width: IvrPixel.px84,
            height: IvrPixel.px84,
          ), //Icon(Icons.live_tv),
          title: Text(
            '游戏进程',
            style: IvrStyle.getFont30(
                color: _page == 0 ? IvrColor.c95F9DE : IvrColor.c7F7F7F),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: IvrAssets.getPng(
                _page == 1 ? "btn_state_selected" : "btn_state_normal"),
            width: IvrPixel.px84,
            height: IvrPixel.px84,
          ), //Icon(Icons.live_tv),
          title: Text(
            '设备状态',
            style: IvrStyle.getFont30(
                color: _page == 1 ? IvrColor.c95F9DE : IvrColor.c7F7F7F),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: IvrAssets.getPng(
                _page == 2 ? "btn_testing_selected" : "btn_testing_normal"),
            width: IvrPixel.px84,
            height: IvrPixel.px84,
          ), //Icon(Icons.live_tv),
          title: Text(
            '分享视频',
            style: IvrStyle.getFont30(
                color: _page == 3 ? IvrColor.c95F9DE : IvrColor.c7F7F7F),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: IvrAssets.getPng(
                _page == 3 ? "btn_testing_selected" : "btn_testing_normal"),
            width: IvrPixel.px84,
            height: IvrPixel.px84,
          ), //Icon(Icons.live_tv),
          title: Text(
            '硬件检测',
            style: IvrStyle.getFont30(
                color: _page == 2 ? IvrColor.c95F9DE : IvrColor.c7F7F7F),
          ),
        ),
      ]);
    } else {
      items.addAll([
        // 2个标签页:设备状态/硬件测试
        BottomNavigationBarItem(
          icon: Icon(Icons.important_devices),
          title: Text('设备状态'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv),
          title: Text('硬件测试'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv),
          title: Text('游戏1'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv),
          title: Text('游戏2'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv),
          title: Text('设置'),
        ),
      ]);
    }

    if (this._page >= items.length) {
      this._page = 0;
    }

    if (newVersion) {
      panels.addAll([
        Battle(Application.dataCenter.settingData),
        AllPc(),
        VideoRecord(0 ,"精英小队"),
        AllHardware(),
      ]);
    } else {
      panels.addAll(<Widget>[
        SectionCalibrationWidget([DeviceDispatcher.MONITOR_CHANGED]),
        SectionHardwareWidget([
          DeviceDispatcher.RELATIONS_CHANGED,
          DeviceDispatcher.STATS_CHANGED
        ]),
        OneGamePanel(id: 's1'),
        OneGamePanel(id: 's2'),
        SettingPanel(Application.dataCenter.settingData),
      ]);
    }

    Widget bottomNavigationBar = BottomNavigationBar(
      //  fixedColor: Colors.red,
      unselectedItemColor: Color(0xffbfbfbf),
      selectedItemColor: Color(0xff616161),
      onTap: navigationTapped,
      currentIndex: _page,
      items: items,
    );

    if (newVersion) {
      bottomNavigationBar = new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: IvrColor.c121212,
        ),
        child: bottomNavigationBar,
      );
    }

    return MaterialApp(
      title: "全感大空间",
      navigatorKey: Application.navState,
      theme: !newVersion
          ? null
          : new ThemeData(
              brightness: Brightness.dark,
              primaryColor: IvrColor.c121212,
              accentColor: Color(0xFFFFFFFF),
              buttonColor: IvrColor.c313131,
            ),
      home: Scaffold(
        appBar: newVersion
            ? null
            : AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(titleBar),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(Application.connection.getStateIcon()),
                  ],
                ),
              ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          var callback = () {
            // 手动连接服务器
            Application.transmit.reconnect();
            Application.tracker.reconnect();
            Application.connection.reconnect();
          };

          // 暂时MQTT不实时返回真正的链接状态,所以这个没办法还
          var isConnected = true;//Application.connection.isConnected();

          return newVersion
              ? GestureDetector(
                  child: refRot2 = IvrRotator2(Image(
                    image: IvrAssets.getPng("btn_refresh"),
                    color: isConnected ? IvrColor.c79F7AD : IvrColor.cFF8181,
                    colorBlendMode: BlendMode.modulate,
                    width: IvrPixel.px210,
                    height: IvrPixel.px221,
                  )),
                  onTap: () {
                    callback();
                    refRot2.doRotate();
                  },
                )
              : FloatingActionButton(
                  child: Icon(Icons.autorenew),
                  onPressed: () {
                    callback();
                  },
                );
        }),
        bottomNavigationBar: bottomNavigationBar,
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: panels,
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    Application.connection.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    globalEvent.onUI(UIID.UI_Settings, () {
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive');
        Application.dataCenter.setForeground(false);
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused');
        Application.dataCenter.setForeground(false);
        break;
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed');
        Application.connection.reconnect();
        Application.dataCenter.setForeground(true);
        Application.hardwareYDL.sendMessage('RegistIp');
        Application.hardwareYDL.sendMessage('GetHardwareOnline');
        break;
      case AppLifecycleState.suspending:
        print('AppLifecycleState.suspending');
        Application.dataCenter.setForeground(false);
        break;
    }

    super.didChangeAppLifecycleState(state);
  }
}
