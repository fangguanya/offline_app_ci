import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/device/device.dart';
import 'package:operator_controller/models/device/switcher.dart';
import 'package:operator_controller/models/device/types.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/calibration/custom_provider.dart';

// 设置tracker的ID映射(序列号)
class DetailTrackerWidget extends IvrNotifiableStatefulWidget {
  final String serial;
  final int id;
  DetailTrackerWidget(List<String> evts, this.serial, this.id)
      : super(evts: evts);

  @override
  DetailTrackerState createState() => DetailTrackerState();
}

class DetailTrackerState extends IvrNotifiableWidgetState<DetailTrackerWidget> {
  TextEditingController newIdController = TextEditingController();
  FocusNode newIdFocus = FocusNode();

  bool isChanged(int c) {
    return c != 0 && c != widget.id;
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context;
    Row r1 = Row(
      children: <Widget>[
        SizedBox(
          width: 130.0,
          child: Text(
            widget.serial,
            style: TextStyle(fontSize: 15.0, color: Color(AppColors.fontColor)),
          ),
        ),
        SizedBox(
          width: 100.0,
          child: TextField(
            focusNode: newIdFocus,
            controller: newIdController,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[0-9\-]")),
            ], //只允许输入小数
            decoration: InputDecoration(hintText: widget.id.toString()),
          ),
        ),
        RaisedButton(
          child: Text("设置"),
          onPressed: () {
            newIdFocus.unfocus();
            int id = int.tryParse(newIdController.value.text) ?? widget.id;
            Application.dataCenter.modifyDevice(widget.serial, id);
          },
//          onPressed: isChanged((int.tryParse(newIdController.value.text) ?? widget.id))
//              ? () {
//                  int id = int.tryParse(newIdController.value.text) ?? widget.id;
//                  Application.dataCenter.modifyDevice(widget.serial, id);
//                }
//              : null,
        ),
      ],
    );
    return r1;
//    List<Widget> w = new List();
//    w.add(r1);
//    return Column(children: w);
  }
}
