
//https://book.flutterchina.club/chapter7/provider.html

// 暂时先不用插件，写一个简单的。以后再用第三方的provider库

import 'package:flutter/widgets.dart';

import 'event_bus.dart';

// 所有的数据，都要继承IvrData，数据变化时，执行下dirty()
class IvrData extends ChangeNotifier {
  void dirty() {
    this.notifyListeners();
  }
}

// todo 有一个弊端，如果data指针变成别的了，是无法监测到的。暂时用事件广播解决（evtId）
// 所有有状态的widget，都要继承自IvrStatefulWidget，提供自己的数据即可。
class IvrStatefulWidget<T extends IvrData> extends StatefulWidget {

  final T data;
  final String evtId;
  IvrStatefulWidget({this.data, this.evtId}) : super();

  @override
  IvrWidgetState createState() => new IvrWidgetState();
}

class IvrWidgetState<T extends IvrStatefulWidget> extends State<T> {

  void refreshUI() {
    if(this.mounted) {
      setState(() => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
  @override
  void initState() {
    if(widget.data != null) {
      widget.data.addListener(refreshUI);
    }
    if(widget.evtId != null && widget.evtId.length > 0) {
      globalEvent.onUI(widget.evtId, refreshUI);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.data != null) {
      widget.data.removeListener(refreshUI);
    }
    if(widget.evtId != null && widget.evtId.length > 0) {
      globalEvent.offUI(widget.evtId);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(IvrStatefulWidget oldWidget) {

    if(oldWidget.data != null) {
      oldWidget.data.removeListener(refreshUI);
    }
    if(oldWidget.evtId != null && oldWidget.evtId.length > 0) {
      globalEvent.offUI(oldWidget.evtId);
    }

    if(widget.data != null) {
      widget.data.addListener(refreshUI);
    }
    if(widget.evtId != null && widget.evtId.length > 0) {
      globalEvent.onUI(widget.evtId, refreshUI);
    }

    super.didUpdateWidget(oldWidget);
  }
}