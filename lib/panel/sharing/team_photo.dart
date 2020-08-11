import 'package:flutter/material.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:operator_controller/panel/sharing/crop_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../style.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

// 队伍的照片信息
//  - 文字显示/拍照按钮/选择按钮
//  - 显示当前选择的照片
class IvrRecordTeamImageWidget extends IvrStatefulWidget<IvrData> {
  String serverTag;
  List<String> photos;
  String selectedPhoto;

  IvrRecordTeamImageWidget(this.serverTag, this.photos, this.selectedPhoto,
      [IvrData d])
      : super(data: d);

  @override
  IvrRecordTeamImageState createState() => IvrRecordTeamImageState();
}

class IvrRecordTeamImageState extends IvrWidgetState<IvrRecordTeamImageWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.serverTag == null || widget.serverTag.length <= 0) {
      return Container();
    }

    return Container(
      height: IvrPixel.px680,
      child: Container(
        margin: EdgeInsets.fromLTRB(IvrPixel.px55, IvrPixel.px20, IvrPixel.px55, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IvrTitle(RichText(
                  text: TextSpan(
                      style: IvrStyle.getFont48(),
                      text: "第2步：选择照片",
                      children: []),
                )),
                IvrButton(
                  "拍摄照片",
                  IvrPixel.px275,
                  callback: () {
                    print("拍摄照片!");
                    getImageFromCamera((url) {});
                  },
                ),
                IvrButton(
                  "选择照片",
                  IvrPixel.px275,
                  callback: () {
                    print("选择照片!");
                    getImageFromGallery((url) {});
                  },
                )
              ],
            ),
//            IvrDivider(
//              margin: EdgeInsets.fromLTRB(IvrPixel.px20, 0, 0, 0),
//            ),
            SizedBox(
              height: IvrPixel.px20,
            ),
            IvrNetworkImage(widget.selectedPhoto),
          ],
        ),
      ),
    );
  }

  // 拍照片
  Future getImageFromCamera(void cb(String i)) async {
    var img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (cb != null) {
      cropImage(img, cb);
    }
    // 自动保存到相册,方便后续选择
    final result = await ImageGallerySaver.saveFile(img.path);
    print("保存相册的文件到:$result");
  }

  // 选择照片
  Future getImageFromGallery(void cb(String i)) async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (cb != null) {
      cropImage(img, cb);
    }
  }

  // 裁剪照片
  Future cropImage(File img, void cb(String i)) async {
    if (img == null) {
      return;
    }
    String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IvrCropPhoto(img, widget.serverTag)));
    if (result == null || result.isEmpty) {
      print("上传失败");
    } else {
      print("上传得到照片网址:$result");
      // 选择得到有效的照片,则修改当前选项
      Application.dataCenter.sharing.selectTeamPhoto(widget.serverTag, result);
      setState(() {
        widget.selectedPhoto = result;
      });
    }
  }
}
