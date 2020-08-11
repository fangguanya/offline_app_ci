import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:operator_controller/logic/helper.dart';

//// 机器详情
//Handler detailRouterHandler = Handler(
//    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//  String v = params["id"]?.first;
//  int i = int.tryParse(v) ?? 0;
//  return WorkerDetail(
//    id: i,
//  );
//});
//
//class Routes {
//  // 机器详情
//  static String detail = "/detail";
//
//  static void configureRoutes(Router router) {
//    router.notFoundHandler = Handler(
//        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//      print("ROUTE WAS NOT FOUND !!!");
//    });
//    router.define(detail, handler: detailRouterHandler);
//  }
//}
