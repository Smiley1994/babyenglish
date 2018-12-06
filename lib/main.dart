import 'package:flutter/material.dart';
import 'package:babyenglish/Constrller/IndexController.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:babyenglish/Constants/Constant.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
      ]);
    } else if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    }


    fluwx.register(appId: Constant.wechatAppId ,doOnIOS: true, doOnAndroid: true, enableMTA: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndexControl(),
    );
  }
}
