import 'package:flutter/widgets.dart';
import 'package:operator_controller/models/core/event_bus.dart';

// 自动注册想要监听的事件,懒得挨个写model了,^ ^
class IvrNotifiableStatefulWidget extends StatefulWidget {
  final List<String> evts;
  const IvrNotifiableStatefulWidget({this.evts}) : super();

  @override
  IvrNotifiableWidgetState createState() => new IvrNotifiableWidgetState();
}

class IvrNotifiableWidgetState<T extends IvrNotifiableStatefulWidget> extends State<T> {
  void refreshUI(d) {
//    print("收到请求,请求重绘...${this.toString()}");
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
  @override
  void initState() {
    if(widget.evts != null) {
      widget.evts.forEach((f){
        if(f.length>0){
          globalEvent.on(f, refreshUI);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.evts != null) {
      widget.evts.forEach((f){
        if(f.length>0){
          globalEvent.off(f, refreshUI);
        }
      });
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(IvrNotifiableStatefulWidget oldWidget) {
    if(oldWidget.evts != null) {
      oldWidget.evts.forEach((f){
        if(f.length>0){
          globalEvent.off(f, refreshUI);
        }
      });
    }

    if(widget.evts != null) {
      widget.evts.forEach((f){
        if(f.length>0){
          globalEvent.on(f, refreshUI);
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }
}