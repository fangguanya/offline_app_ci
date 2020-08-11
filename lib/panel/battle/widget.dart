/**
 * Auth :   liubo
 * Date :   2020/5/9 10:13
 * Comment: 二次封装widget
 */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../style.dart';

// 单选按钮
class IvrRadio extends StatelessWidget {
  final bool selected;
  final String imageUnSelected;
  final String imageSelected;
  final double width;
  final double height;
  final VoidCallback callback;

  IvrRadio(
    this.selected, {
    this.imageUnSelected = "single_election_normal",
    this.imageSelected = "single_election_selected",
    this.width = 0,
    this.height = 0,
    this.callback,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget w = Image(
      image: IvrAssets.getPng(!this.selected ? imageUnSelected : imageSelected),
      width: this.width > 0 ? this.width : IvrPixel.px60,
      height: this.height > 0 ? this.height : IvrPixel.px60,
    );

    if (this.callback != null) {
      w = GestureDetector(
        child: w,
        onTap: this.callback,
      );
    }

    return w;
  }
}

class IvrRadioMan extends StatelessWidget {
  final bool selected;
  final VoidCallback callback;

  IvrRadioMan(this.selected, this.callback) : super();

  @override
  Widget build(BuildContext context) {
    return IvrRadio(this.selected,
        imageUnSelected: "btn_men_normal",
        imageSelected: "btn_men_selected",
        width: IvrPixel.px170,
        height: IvrPixel.px72,
        callback: callback);
  }
}

class IvrRadioWoman extends StatelessWidget {
  final bool selected;
  final VoidCallback callback;

  IvrRadioWoman(this.selected, this.callback) : super();

  @override
  Widget build(BuildContext context) {
    return IvrRadio(this.selected,
        imageUnSelected: "btn_women_normal",
        imageSelected: "btn_women_selected",
        width: IvrPixel.px170,
        height: IvrPixel.px72,
        callback: callback);
  }
}

// 复选按钮
class IvrCheck extends StatefulWidget {
  bool selected;
  ValueChanged<bool> onChanged;

  IvrCheck(this.selected, {this.onChanged}) : super();

  @override
  IvrCheckState createState() => IvrCheckState();
}

// 单选框
class IvrCheckState extends State<IvrCheck> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selected = !widget.selected;
        if (widget.onChanged != null) {
          widget.onChanged(widget.selected);
        }
        setState(() {});
      },
      child: Image(
        image: IvrAssets.getPng(!widget.selected
            ? "multiple_selection_normal"
            : "multiple_selection_selected"),
        width: IvrPixel.px60,
        height: IvrPixel.px60,
      ),
    );
  }
}

// 分割线
class IvrDivider extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final double height;

  IvrDivider({this.margin, this.height = 2}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Divider(
        height: height,
      ),
    );
  }
}

// 圆角panel
class IvrPanel extends StatelessWidget {
  final Widget child;

  IvrPanel(this.child) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: IvrColor.c1C1C1D,
        borderRadius: BorderRadius.all(Radius.circular(IvrPixel.px26)),
      ),
      child: child,
    );
  }
}

// 圆角高亮
class IvrPanel2 extends StatelessWidget {
  final Widget child;

  IvrPanel2(this.child) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
//        image: DecorationImage(
//          fit: BoxFit.fill,
//          centerSlice: Rect.fromLTWH(20, 20, 52, 52),
//          image: IvrAssets.getPng("bg1"),
//
//        ),
        color: IvrColor.c1C1C1D,
        borderRadius: BorderRadius.all(Radius.circular(IvrPixel.px26)),
        border: Border.all(color: Color(0x8095F9DE), width: IvrPixel.px3),
        boxShadow: [
          BoxShadow(
            color: Color(0x8095F9DE),
            spreadRadius: IvrPixel.px0,
            blurRadius: IvrPixel.px12,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
            colors: [Color(0xFF323534), Color(0xFF1C1C1D)]),
      ),
      child: Container(
        margin: EdgeInsets.all(IvrPixel.px0),
        child: child,
      ),
    );
  }
}

// 圆角不亮
class IvrPanel3 extends StatelessWidget {
  final Widget child;

  final double width;

  IvrPanel3(this.child, {this.width}) : super();

  @override
  Widget build(BuildContext context) {
    var width = this.width;
    if (width == null) {
      width = IvrPixel.px50;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          centerSlice: Rect.fromLTWH(20, 20, 52, 52),
          image: IvrAssets.getPng("bg0"),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(width),
        child: child,
      ),
    );
  }
}

class IvrTitle extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;

  IvrTitle(this.leftChild, {this.rightChild}) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: IvrPixel.px10,
            ),
            leftChild,
          ],
        ),
        this.rightChild == null
            ? Container()
            : Container(
                padding: EdgeInsets.fromLTRB(IvrPixel.px28_8, IvrPixel.px11,
                    IvrPixel.px28_8, IvrPixel.px11),
                decoration: new BoxDecoration(
                  color: IvrColor.c1C1C1D,
                  borderRadius:
                      BorderRadius.all(Radius.circular(IvrPixel.px26)),
                ),
                child: this.rightChild,
              )
      ],
    );
  }
}

// 一种标题样式
class IvrTitle1 extends StatelessWidget {
  final String title;
  final Widget rightChild;

  IvrTitle1(this.title, {this.rightChild}) : super();

  @override
  Widget build(BuildContext context) {
    return IvrTitle(
      Text(
        title,
        style: IvrStyle.getFont48(),
      ),
      rightChild: rightChild,
    );
  }
}

// 按钮（渐变色）
class IvrButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback callback;
  final bool disable;

  IvrButton(this.text, this.width, {this.callback, this.disable = false});

  @override
  Widget build(BuildContext context) {
    var buttonColor = [IvrColor.c313131, IvrColor.c313131];
    var textColor = IvrColor.cE8E8E8;
    if (!this.disable) {
      buttonColor = [IvrColor.c9AFFD8, IvrColor.c7FDEFF];
      textColor = IvrColor.c000000;
    }

    return Container(
      height: IvrPixel.px120,
      width: this.width,
      //margin: EdgeInsets.fromLTRB(30, 35, 30, 0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
              colors: buttonColor), // 渐变色
          borderRadius: BorderRadius.circular(5)),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(IvrPixel.px12)),
        color: Colors.transparent,
        // 设为透明色
        elevation: 0,
        // 正常时阴影隐藏
        highlightElevation: 0,
        // 点击时阴影隐藏
        onPressed: () {
          if (this.callback != null) {
            this.callback();
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            this.text,
            style: IvrStyle.getFont48(color: textColor),
          ),
        ),
      ),
    );
  }
}

// 按钮（黑色亮边）
class IvrButton3 extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback callback;
  final bool disable;

  IvrButton3(this.text, this.width, {this.callback, this.disable = false});

  @override
  Widget build(BuildContext context) {
    var buttonColor = [IvrColor.c313131, IvrColor.c313131];
    var textColor = IvrColor.cE8E8E8;
//    if (!this.disable) {
//      buttonColor = [IvrColor.c9AFFD8, IvrColor.c7FDEFF];
//      textColor = IvrColor.c000000;
//    }

    return Container(
      height: IvrPixel.px120,
      width: this.width,
      //margin: EdgeInsets.fromLTRB(30, 35, 30, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
            colors: buttonColor), // 渐变色
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: IvrColor.c494949, width: IvrPixel.px3),
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(IvrPixel.px12)),
        color: Colors.transparent,
        // 设为透明色
        elevation: 0,
        // 正常时阴影隐藏
        highlightElevation: 0,
        // 点击时阴影隐藏
        onPressed: () {
          if (this.callback != null) {
            this.callback();
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            this.text,
            style: IvrStyle.getFont48(color: textColor),
          ),
        ),
      ),
    );
  }
}

class IvrButton33 extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback callback;
  final bool disable;

  IvrButton33(this.text, this.width, {this.callback, this.disable = false});

  @override
  Widget build(BuildContext context) {
    var buttonColor = [IvrColor.c313131, IvrColor.c313131];
    var textColor = IvrColor.cFFFFFF;
    if (!this.disable) {
      buttonColor = [IvrColor.c313131, IvrColor.c313131];
      textColor = IvrColor.cFFFFFF;
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          centerSlice: Rect.fromLTWH(10, 10, 44, 44),
          image: IvrAssets.getPng("btn_bg1"),
        ),
      ),
      //margin: EdgeInsets.all(Pixel.px20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Colors.transparent,
        // 设为透明色
        elevation: 0,
        // 正常时阴影隐藏
        highlightElevation: 0,
        // 点击时阴影隐藏
        onPressed: () {
          if (this.callback != null) {
            this.callback();
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            this.text,
            style: IvrStyle.getFont48(color: textColor),
          ),
        ),
      ),
    );
  }
}

// 文字按钮
class IvrButton2 extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  IvrButton2(this.text, {this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        "$text",
        style: IvrStyle.getFont36(color: IvrColor.c95F9DE),
      ),
      onTap: callback,
    );
  }
}

// 文字按钮
class IvrButton4 extends StatelessWidget {
  final bool open;
  final VoidCallback callback;

  IvrButton4(this.open, {this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image(
        image: IvrAssets.getPng(this.open ? "switch_open" : "switch_close"),
        width: IvrPixel.px124,
        height: IvrPixel.px68,
      ),
      onTap: callback,
    );
  }
}

// 进度条
class IvrProgressBar extends StatelessWidget {
  double p;
  final double width;

  IvrProgressBar(this.p, this.width);

  @override
  Widget build(BuildContext context) {
    if (p == null || p < 0) {
      p = 0;
    }

    var colors = [IvrColor.c7FDEFF, IvrColor.c9AFFD8];
    if (p < 0.3) {
      colors = [IvrColor.cFF7D7D, IvrColor.cFF8181];
    }
    if (p > 1) {
      p = 1;
    }

    return Stack(
      children: <Widget>[
        Container(
            height: IvrPixel.px20,
            width: this.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
                    colors: [IvrColor.c313131, IvrColor.c313131]), // 渐变色
                borderRadius: BorderRadius.circular(15))),
        Container(
            height: IvrPixel.px20,
            width: this.width * p,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    //colors: [IvrColor.c9AFFD8, IvrColor.c7FDEFF]), // 渐变色
                    colors: colors), // 渐变色
                borderRadius: BorderRadius.circular(15))),
      ],
    );
  }
}

// 输入框
class IvrTextField extends StatefulWidget {
  String defaultContent;
  int maxLength;
  ValueChanged<String> onEditComplete;
  Color color;

  IvrTextField({this.defaultContent, this.color, this.maxLength = 15, this.onEditComplete})
      : super();

  @override
  IvrTextFieldState createState() => IvrTextFieldState();
}

class IvrTextFieldState extends State<IvrTextField> {
  final FocusNode _focusNode = FocusNode();

  TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("FOCUS=${_focusNode.hasFocus}");
      if (widget.onEditComplete != null) {
        widget.onEditComplete(_editController.value.text);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 输出处理controller
    if (_editController == null){
      _editController = new TextEditingController.fromValue(
          TextEditingValue(
              text: widget.defaultContent,
              selection: new TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: widget.defaultContent.length))));
    }

    // 真正的输入控件
    TextField textField = new TextField(
      controller: _editController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        counterText: "",
        hintStyle: TextStyle(color: IvrColor.cFFFFFF),
        border: UnderlineInputBorder(),
        fillColor: Colors.transparent,
        filled: true,
      ),
      onSubmitted: (str) {
        if (widget.onEditComplete != null) {
          widget.onEditComplete(_editController.value.text);
        }
      },
      keyboardType: TextInputType.text,
      maxLength: widget.maxLength,
      maxLines: 1,
      inputFormatters: null,
      style: TextStyle(color: widget.color),
      obscureText: false,
    );
    return textField;
  }
}

// 旋转
class IvrRotator extends StatefulWidget {
  final Widget child;

  IvrRotator(this.child) : super();

  @override
  IvrRotatorState createState() => IvrRotatorState();
}

class IvrRotatorState extends State<IvrRotator>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animationController,
      child: widget.child,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //重置起点
        animationController.reset();
        //开启
        animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    animationController.dispose();
  }
}

// 旋转
class IvrRotator2 extends StatefulWidget {
  final Widget child;

  IvrRotator2State state;

  void doRotate() {
    if (state != null && state.animationController != null) {
      state.animationController.reset();
      state.animationController.forward();
    }
  }

  IvrRotator2(this.child) : super();

  @override
  IvrRotator2State createState() => IvrRotator2State();
}

class IvrRotator2State extends State<IvrRotator2>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  Widget build(BuildContext context) {
    widget.state = this;

    return RotationTransition(
      alignment: Alignment(0, 0),
      turns: animationController,
      child: widget.child,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationController.addListener(() {
      setState(() {});
    });

//    animationController.forward();
//    animationController.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
//        //重置起点
//        animationController.reset();
//        //开启
//        animationController.forward();
//      }
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    animationController.dispose();
  }
}

// 平分
class IvrRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  IvrRow({this.children, this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    var list = new List<Widget>();

    if (children != null) {
      int flex = 10;
      if (list.length == 3) {
        flex = 8;
      }

      children.forEach((k) {
        if (list.length > 0) {
          list.add(Spacer());
        }
        list.add(Expanded(
          child: k,
          flex: flex,
        ));
      });
    }

    return Row(
      children: list,
    );
  }
}

// 带文字单选按钮
class IvrTextRadio extends StatelessWidget {
  final bool selected;
  final String imageUnSelected;
  final String imageSelected;
  final double width;
  final double height;
  final VoidCallback callback;
  final String content;

  IvrTextRadio(
    this.content,
    this.callback,
    this.selected, {
    this.imageUnSelected = "single_election_normal",
    this.imageSelected = "single_election_selected",
    this.width = 0,
    this.height = 0,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget w = Row(
      children: <Widget>[
        Text(
          content,
          style: IvrStyle.getFont44(color: IvrColor.cFFFFFF),
        ),
        Image(
          image: IvrAssets.getPng(
              !this.selected ? imageUnSelected : imageSelected),
          width: this.width > 0 ? this.width : IvrPixel.px60,
          height: this.height > 0 ? this.height : IvrPixel.px60,
        )
      ],
    );

    if (this.callback != null) {
      w = GestureDetector(
        child: w,
        onTap: this.callback,
      );
    }

    return w;
  }
}

// 自动吃焦点
class IvrFocusGestureDetector extends StatelessWidget {
  final Widget child;

  IvrFocusGestureDetector({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}

// 网络照片
class IvrNetworkImage extends StatelessWidget {
  final String url;
  IvrNetworkImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xFFFF0000), width: 0.5), // 边色与边宽度
          color: Color(0xFF9E9E9E), // 底色
        ),
      child: CachedNetworkImage(
        imageUrl: url,
        height: IvrPixel.px500,
        fit: BoxFit.fitHeight,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    )
      ;
  }
}
