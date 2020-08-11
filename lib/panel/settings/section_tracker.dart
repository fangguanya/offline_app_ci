import 'package:flutter/material.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/calibration/custom_provider.dart';
import 'package:operator_controller/panel/hardware/detail_hardware.dart';
import 'package:operator_controller/panel/settings/detail_tracker.dart';

class SectionTrackerWidget extends IvrNotifiableStatefulWidget {
  const SectionTrackerWidget(List<String> evts) : super(evts: evts);

  @override
  SectionTrackerState createState() => SectionTrackerState();
}

class SectionTrackerState extends IvrNotifiableWidgetState<SectionTrackerWidget> {
  @override
  Widget build(BuildContext context) {
//    print("重新绘制了....section_tracker");
    Application.context = context;
    List<Widget> items = new List();
    Application.dataCenter.reflects.forEach((s,i) {
      items.add(Row(children: <Widget>[DetailTrackerWidget([DeviceDispatcher.REFLECT_STATE_CHANGED], s, i)],));
    });
    if (items.length == 0){
      items.add(Row(children: <Widget>[Text("请先开启TRACKER")],));
    }
    //添加分割线
    var divideListItem = ListTile.divideTiles(tiles: items, context: context, color: Colors.pink).toList();

    return Column(children: divideListItem,);
  }
}
