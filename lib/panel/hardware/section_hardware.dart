import 'package:flutter/material.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/calibration/custom_provider.dart';
import 'package:operator_controller/panel/hardware/detail_hardware.dart';

// 显示所有硬件列表并测试
class SectionHardwareWidget extends IvrNotifiableStatefulWidget {
  const SectionHardwareWidget(List<String> evts) : super(evts: evts);

  @override
  SectionHardwareState createState() => SectionHardwareState();
}

Color getStatusColor(int i) {
  int s = Application.dataCenter.getCalibrationStatus();
  if (s == i) {
    return Color(0xff00ff00);
  }
  return Color(0xff000000);
}

class SectionHardwareState
    extends IvrNotifiableWidgetState<SectionHardwareWidget> {
  Color getStatusColor(int i) {
    int s = Application.dataCenter.getCalibrationStatus();
    if (s == i) {
      return Color(0xff00ff00);
    }
    return Color(0xff000000);
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context;
    List<Widget> items = new List();
    items.addAll(Application.dataCenter.hardwareRelations.where((data) {
      return data.visible;
    }).map((data) {
      Device d = Application.dataCenter.getHardwareByRelation(data);
      return DetailHardwareWidget([DeviceDispatcher.DEVICE_CHANGED], d, data);
    }).toList());

    if (!Application.dataCenter.settingData.data.useYdl) {
      items.add(Row(
        children: <Widget>[
          RaisedButton(
            child: Text("停止所有"),
            onPressed: () {
              Application.connection.sendMessage(Protocol.TopicsClose, "");
            },
          ),
        ],
      ));
      items.add(Row(
        children: <Widget>[
          RaisedButton(
            child: Text("HTC",
                style: TextStyle(fontSize: 15.0, color: getStatusColor(0))),
            onPressed: () {
              Application.dataCenter.setCalibrationStatus(0);
            },
          ),
          RaisedButton(
            child: Text("RIFTS",
                style: TextStyle(fontSize: 15.0, color: getStatusColor(1))),
            onPressed: () {
              Application.dataCenter.setCalibrationStatus(1);
            },
          ),
          RaisedButton(
            child: Text("HYBRID",
                style: TextStyle(fontSize: 15.0, color: getStatusColor(2))),
            onPressed: () {
              Application.dataCenter.setCalibrationStatus(2);
            },
          ),
        ],
      ));
    }
    //添加分割线
    var divideListItem =
        ListTile.divideTiles(tiles: items, context: context, color: Colors.pink)
            .toList();

    return Container(
        margin: EdgeInsets.symmetric(horizontal: Constants.pageMargin),
        child: ListView(
          children: divideListItem,
        ));
  }
}
