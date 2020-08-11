import 'package:flutter/material.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/switcher.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/calibration/custom_provider.dart';

// 显示1个硬件设备是否在线
class DetailHardwareWidget extends IvrNotifiableStatefulWidget {
  final Device device;
  final WorkerRelation relation;
  const DetailHardwareWidget(List<String> evts, this.device, this.relation)
      : super(evts: evts);

  @override
  DetailHardwareState createState() => DetailHardwareState();
}

class DetailHardwareState
    extends IvrNotifiableWidgetState<DetailHardwareWidget> {
  String getDesc() {
    if (widget.device == null) {
      return "关机";
    }
    var s = widget.device.status();
    if (s == DeviceStateValue.IDLE) {
      if (widget.device is Switcher) {
        int idx = int.parse(widget.relation.param) ?? 0;
        if ((widget.device as Switcher).isSwitchOn(idx)) {
          return "运行中";
        }
      }
      return "已开机";
    }
    if (s == DeviceStateValue.CONN) {
      return "连接外设中";
    }
    if (s == DeviceStateValue.OFF) {
      return "关机";
    }
    if (s == DeviceStateValue.RUN) {
      return "运行中";
    }
    return "未知";
  }

  Color getDescColor() {
    if (widget.device == null) {
      return Color(0xffff0000);
    }
    var s = widget.device.status();
    if (s == DeviceStateValue.IDLE) {
      if (widget.device is Switcher) {
        int idx = int.parse(widget.relation.param) ?? 0;
        if ((widget.device as Switcher).isSwitchOn(idx)) {
          return Color(0xffffff00);
        }
      }
      return Color(0xff00ff00);
    }
    if (s == DeviceStateValue.CONN) {
      return Color(0xffff0000);
    }
    if (s == DeviceStateValue.OFF) {
      return Color(0xffff0000);
    }
    if (s == DeviceStateValue.RUN) {
      return Color(0xffffff00);
    }
    return Color(0xff000000);
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context;
    Row r1 = Row(
      children: <Widget>[
        Text(
          widget.relation.name,
          style: TextStyle(fontSize: 15.0, color: Color(AppColors.lightGray)),
        ),
        SizedBox(
          width: 9.0,
        ),
        Icon(
          Icons.code,
        ),
      ],
    );
    Column c1 = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "当前运行状态:",
              style:
                  TextStyle(fontSize: 15.0, color: Color(AppColors.lightGray)),
            ),
            Text(
              getDesc(),
              style: TextStyle(fontSize: 15.0, color: getDescColor()),
            ),
          ],
        ),
//          Row(
//            children: <Widget>[
//              Text(
//                "校准状态:",
//                style: TextStyle(fontSize: 15.0, color: Color(AppColors.lightGray)),
//              ),
//              Text(
//                widget.device.isCalibrationRunning() ? "正在校准" : "空闲",
//                style: TextStyle(
//                    fontSize: 15.0,
//                    color: widget.device.isCalibrationRunning() ? Color(0xff00ff00) : Color(AppColors.lightGray)),
//              ),
//            ],
//          ),
      ],
    );
    Row r2 = Row(
      children: <Widget>[
        RaisedButton(
          child: Text("开启设备"),
          onPressed: () {
            if (widget.device != null) {
              widget.device.turnOn(widget.relation.param);
            }
          },
        ),
        RaisedButton(
          child: Text("关闭"),
          onPressed: () {
            if (widget.device != null) {
              widget.device.turnOff(widget.relation.param);
            }
          },
        )
      ],
    );

    List<Widget> w = new List();
    w.add(r1);
    w.add(c1);
    if (widget.relation.exec) {
      w.add(r2);
    }
    return Column(children: w);
  }
}
