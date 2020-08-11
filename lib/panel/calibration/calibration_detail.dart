import 'package:flutter/material.dart';
import 'package:operator_controller/dialogs/toast.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/monitor.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/calibration/custom_provider.dart';

class CalibrationDetailWidget extends IvrNotifiableStatefulWidget {
  final Monitor device;
  final WorkerRelation relation;
  const CalibrationDetailWidget(List<String> evts, this.device, this.relation)
      : super(evts: evts);

  @override
  CalibrationDetailState createState() => CalibrationDetailState();
}

class CalibrationDetailState
    extends IvrNotifiableWidgetState<CalibrationDetailWidget> {
  String getBattery() {
    if (widget.device == null) {
      return "--";
    }
    var s = widget.device.status();
    if (s == DeviceStateValue.OFF) {
      return "--";
    }
    return widget.device.getBatteryPercentage().toString() + "%";
  }

  String getTrackerBattery() {
    if (widget.device == null) {
      return "--";
    }
    var s = widget.device.status();
    if (s == DeviceStateValue.OFF) {
      return "--";
    }
    return widget.device.getTrackerBatteryPercentage().toString() + "%";
  }

  String getDesc() {
    if (widget.device == null) {
      return "关机";
    }
    var s = widget.device.status();
    if (s == DeviceStateValue.OFF) {
      return "关机";
    }
    return "已开机";
  }

  Color getDescColor() {
    if (widget.device == null) {
      return Color(0xffff0000);
    }
    var s = widget.device.status();
    if (s == DeviceStateValue.OFF) {
      return Color(0xffff0000);
    }
    return Color(0xff00ff00);
  }

  String getName() {
    if (widget.device == null) {
      return widget.relation.name;
    }
    return widget.relation.name + ":" + widget.device.ip;
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context;
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Text(
            getName(),
            style: TextStyle(fontSize: 15.0, color: Color(AppColors.lightGray)),
          ),
          SizedBox(
            width: 9.0,
          ),
          Text(
            "pc=" + getBattery() + ",tracker=" + getTrackerBattery(),
            style: TextStyle(fontSize: 15.0, color: Color(AppColors.lightGray)),
          ),
          Icon(
            Icons.code,
          ),
          Text(
            getDesc(),
            style: TextStyle(fontSize: 15.0, color: getDescColor()),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          RaisedButton(
            child: Text("开始校准"),
            onPressed: () {
              if (widget.device != null) {
                widget.device.turnOn("fixer.exe");
              } else {
                OneDialog.showDialogOkCancel(context, "当前设备进程未启动,无法进行测试!");
              }
            },
          ),
          RaisedButton(
            child: Text("停止校准"),
            onPressed: () {
              if (widget.device != null) {
                widget.device.turnOff("fixer.exe");
              } else {
                OneDialog.showDialogOkCancel(context, "当前设备进程未启动,无法进行测试!");
              }
            },
          )
        ],
      ),
//      Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Text(
//                "头显状态:",
//                style: TextStyle(
//                    fontSize: 15.0, color: Color(AppColors.lightGray)),
//              ),
//              Text(
//                getRunning(),
//                style: TextStyle(fontSize: 15.0, color: getRunningColor()),
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Text(
//                "穿戴?:",
//                style: TextStyle(
//                    fontSize: 15.0, color: Color(AppColors.lightGray)),
//              ),
//              Text(
//                getMount(),
//                style: TextStyle(
//                    fontSize: 15.0, color: getMountColor()),
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Text(
//                "丢失?:",
//                style: TextStyle(
//                    fontSize: 15.0, color: Color(AppColors.lightGray)),
//              ),
//              Text(
//                getLost(),
//                style: TextStyle(
//                    fontSize: 15.0, color: getLostColor()),
//              ),
//            ],
//          )
//        ],
//      ),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "进程状态:",
                style: TextStyle(
                    fontSize: 15.0, color: Color(AppColors.lightGray)),
              ),
              Text(
                getRunning(),
                style: TextStyle(fontSize: 15.0, color: getRunningColor()),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "校准状态:",
                style: TextStyle(
                    fontSize: 15.0, color: Color(AppColors.lightGray)),
              ),
              Text(
                getCalibrationRunning(),
                style: TextStyle(
                    fontSize: 15.0, color: getCalibrationRunningColor()),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "前一次结果:",
                style: TextStyle(
                    fontSize: 15.0, color: Color(AppColors.lightGray)),
              ),
              Text(
                getCalibrationResult(),
                style: TextStyle(
                    fontSize: 15.0, color: Color(AppColors.lightGray)),
              ),
            ],
          )
        ],
      )
    ]);
  }

  String getCalibrationResult() {
    if (widget.device == null) {
      return "关机";
    }
    return widget.device.prevCalibrationResult;
  }

  Color getCalibrationRunningColor() {
    if (widget.device == null) {
      return Color(AppColors.lightGray);
    }
    return widget.device.isCalibrationRunning()
        ? Color(0xff00ff00)
        : Color(AppColors.lightGray);
  }

  String getCalibrationRunning() {
    if (widget.device == null) {
      return "关机";
    }
    return widget.device.isCalibrationRunning() ? "正在校准" : "空闲";
  }

  Color getRunningColor() {
    if (widget.device == null) {
      return Color(AppColors.lightGray);
    }
    return widget.device.isRunning("fixer.exe")
        ? Color(0xff00ff00)
        : Color(AppColors.lightGray);
  }

  String getRunning() {
    if (widget.device == null) {
      return "关机";
    }
    return widget.device.isRunning("fixer.exe") ? "运行中" : "未启动";
  }

  // 头显佩戴情况
  Color getMountColor() {
    if (widget.device == null) {
      return Color(AppColors.lightGray);
    }
    return widget.device.getHMDMounted()
        ? Color(0xff00ff00)
        : Color(0xffff0000);
  }

  String getMount() {
    if (widget.device == null) {
      return "否";
    }
    return widget.device.getHMDMounted() ? "是" : "否";
  }
  Color getLostColor() {
    if (widget.device == null) {
      return Color(AppColors.lightGray);
    }
    return widget.device.getHMDLosted()
        ? Color(0xffff0000)
        : Color(0xff00ff00);
  }

  String getLost() {
    if (widget.device == null) {
      return "否";
    }
    return widget.device.getHMDLosted() ? "是" : "否";
  }
}
