import 'package:flutter/material.dart';
import 'package:operator_controller/logic/application.dart';
import 'package:operator_controller/logic/constants.dart';
import 'package:operator_controller/models/core/event_bus.dart';
import 'package:operator_controller/models/core/provider.dart';
import 'package:operator_controller/models/protocol.dart';
import 'package:operator_controller/panel/battle/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop/image_crop.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert'; // JSON库
import '../style.dart';
import 'package:operator_controller/panel/sharing/screen_util.dart';
import 'package:operator_controller/dialogs/toast.dart';

// 照片截取的page内容
class IvrCropPhotoBody extends StatefulWidget {
  File image;
  String serverTag;
  IvrCropPhotoBody(this.image, this.serverTag);

  @override
  IvrCropPhotoBodyState createState() => new IvrCropPhotoBodyState();
}

class IvrCropPhotoBodyState extends State<IvrCropPhotoBody> {
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: ScreenUtil.screenHeight * 0.8,
          width: ScreenUtil.screenWidth,
          child: Crop.file(
            widget.image,
            key: cropKey,
//            aspectRatio: 4 / 3,
            aspectRatio: 1,
            alwaysShowGrid: true,
          ),
        ),
        IvrButton(
          "确认",
          IvrPixel.px275,
          callback: () {
            cropImage(widget.image, (f, err) {
              if (err == null || err.length <= 0) {
                if (f == null) {
                  popResult("");
                } else {
                  uploadImage(f, (url, err) {
                    if (err == null || err.length <= 0) {
                      popResult(url);
                    } else {
                      OneDialog.showDialogOk(context, '上传错误:$err!');
                    }
                  });
                }
              } else {
                OneDialog.showDialogOk(context, '裁剪错误:$err!');
              }
            });
          },
        ),
      ],
    );
  }

  // 返回
  void popResult(String url) {
    Navigator.pop(context, url);
  }

  // 执行裁剪
  Future cropImage(File img, void cb(File i, String err)) async {
    final crop = cropKey.currentState;
    final area = crop.area;
    if (area == null) {
      print("裁剪不成功!");
    }
    await ImageCrop.requestPermissions().then((value) {
      if (value) {
        ImageCrop.cropImage(
          file: img,
          area: crop.area,
        ).then((value) {
          if (cb != null) {
            cb(value, "");
          }
        }).catchError((o) {
          print("裁剪真的不成功!");
          cb(null, o.toString());
        }, test: (obj) {
          return false;
        });
      } else {
        print("没有授权,那就直接使用原始文件吧");
        if (cb != null) {
          cb(img, "请求授权失败!");
        }
      }
    });
  }

  // 上传照片
  Future uploadImage(File f, void cb(String url, String err)) async {
    var t = Application.dataCenter.sharing.getTeamWithTag(widget.serverTag);
    FormData formData = FormData.from({
      "file": UploadFileInfo(f, "xxx.png"),
      "game": t.selectedgame,
      "tag": widget.serverTag,
      "team": t.id,
      "player": 0,
      "ext": "png",
    });
    String url = "";
    String error = "";
    try {
      var response = await Dio().post(
          Application.dataCenter.settingData.data.recordAddress,
          data: formData);
      print("请求保存图片结果:$response");
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.data);
        HttpUploadPhotoResult w = HttpUploadPhotoResult.fromJson(list);
        if (w.success) {
          url = w.url;
        }
        if (w.error != null && w.error.isNotEmpty) {
          error = w.error;
          print("服务器返回错误:${w.error}");
        }
      }
    } catch (e) {
      error = e.toString();
      print("出现了错误=$e");
    }
    if (cb != null) {
      cb(url, error);
    }
  }
}

// 对得到的照片进行裁剪
class IvrCropPhoto extends StatefulWidget {
  File image;
  String serverTag;
  IvrCropPhoto(this.image, this.serverTag);

  @override
  IvrCropPhotoState createState() => new IvrCropPhotoState();
}

class IvrCropPhotoState extends State<IvrCropPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IvrColor.c000000,
      appBar: AppBar(
        title: Center(
          child: Text("选择图片上传"),
        ),
      ),
      body: Container(
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: IvrCropPhotoBody(widget.image, widget.serverTag),
      ),
    );
  }
}
