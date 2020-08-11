import 'package:operator_controller/models/device_state.dart';

import 'gameviewport.dart';

/**
 * Auth :   liubo
 * Date :   2019/11/21 9:40
 * Comment: 所有设备
 */

class NewMyGameviewportAllDevices extends NewMyGame {
  NewMyGameviewportAllDevices({width = 0}) : super(width:width) {

    if(true) {
      var fakeGameinfo = OneGameData();

      var devices = ["c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8"];
      devices.forEach((v) {
        fakeGameinfo.clients[v] = null;
      });

      setGameData(fakeGameinfo);
    }
  }
}