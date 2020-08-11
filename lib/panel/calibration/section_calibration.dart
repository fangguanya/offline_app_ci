import 'package:flutter/material.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/monitor.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/panel/calibration/calibration_detail.dart';
import 'package:operator_controller/panel/calibration/custom_provider.dart';
import 'package:operator_controller/panel/onegame/gameviewport_alldevices.dart';

class SectionCalibrationWidget extends IvrNotifiableStatefulWidget {
  const SectionCalibrationWidget(List<String> evts) : super(evts: evts);

  @override
  SectionCalibrationState createState() => SectionCalibrationState();
}

class SectionCalibrationState extends IvrNotifiableWidgetState<SectionCalibrationWidget> {

  MyGameviewportAllDevices mygame;
  
  @override
  Widget build(BuildContext context) {
    Application.context = context;
    List<Widget> items = new List();

    if(mygame == null) {
      mygame = MyGameviewportAllDevices();
    }
    items.add(mygame.widget);
    items.addAll(Application.dataCenter.pcRelations.map((data) {
      if (data.type == DeviceType.MONITOR) {
        Monitor d = Application.dataCenter.getMonitor(data.id);
        return CalibrationDetailWidget([DeviceDispatcher.MONITOR_DETAIL_CHANGED,DeviceDispatcher.MONITOR_CHANGED], d, data);
      }
      print("PC电脑配置错误,类型应该=100,但是目前=" + data.type.toString());
    }).toList());
    
    //添加分割线
    var divideListItem = ListTile.divideTiles(tiles: items, context: context, color: Colors.pink).toList();
    return Container(
        margin: EdgeInsets.symmetric(horizontal: Constants.pageMargin),
        child: ListView(
          children: divideListItem,
        ));
  }
}
