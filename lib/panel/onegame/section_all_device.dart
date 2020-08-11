

import 'package:flutter/widgets.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/device_state.dart';
import 'package:operator_controller/models/core/provider.dart';

import '../style.dart';

class SectionAllDevice extends IvrStatefulWidget<IvrData> {

  SectionAllDevice() : super(evtId:UIID.UI_AllDevices);

  @override
  SectionAllDeviceState createState() => new SectionAllDeviceState();
}

class SectionAllDeviceState extends IvrWidgetState<SectionAllDevice> {
  @override
  Widget build(BuildContext context) {

//    var data = widget.data;
//    if(data == null) {
//      return Text('invalide data. [${this.runtimeType.toString()}]');
//    }

    var devices = List<Widget>();
    devices.add(Text('设备状态', textScaleFactor: 1.5,));

    Application.dataCenter.hardwareRelations.forEach((v){
      Device d = Application.dataCenter.getHardwareByRelation(v);

      DeviceStateValue status = DeviceStateValue.OFF;
      if (d != null) {
        status = d.status();
      }

      devices.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Text(v.name),
        Text(status.getDesc(), style: IvrStyle.getDeviceStateTextStyle(status),)
      ],));
    });


    var root = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: devices,
      ),
    );

    return root;

  }
}