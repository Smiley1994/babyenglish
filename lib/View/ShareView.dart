import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ShareWidget extends StatelessWidget {
  final bool visible;
  ShareWidget({this.visible});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final backGroupHeight = 200.0;

    return Offstage(
      offstage: visible,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: screenHeight - backGroupHeight),
            height: backGroupHeight,
            width: double.infinity,
//            color: Colors.black54,
            child: Image.asset(
              Constant.dirImage + 'ShareApp_background@2x.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: screenHeight - backGroupHeight + 35),
              height: 23.0,
              child: Image.asset(
                Constant.dirImage + "分享app至@3x.png",
                fit: BoxFit.fitHeight,
              )),
          Container(
            alignment: AlignmentDirectional.topCenter,
            margin: EdgeInsets.only(top: screenHeight - backGroupHeight + 75),
            height: 100.0,
            width: screenWidth - 100,
//            width: double.infinity,
            child: Row(
              children: <Widget>[
                buildPlatformButtons(
                    "WeChat@3x.png", 0, (screenWidth - 100) / 2, 55.0, "微信好友@3x.png"),
                buildPlatformButtons("Circle_of_friends@3x.png", 1,
                    (screenWidth - 100) / 2, 55.0, "微信朋友圈@3x.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildPlatformButtons(String imageName, int type, double width,
      double imageHeight, String platformName) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            width: width,
            height: imageHeight,
            child: Image.asset(
              Constant.dirImage + imageName,
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              height: 22.0,
              child: Image.asset(
                Constant.dirImage + platformName,
                fit: BoxFit.fitHeight,
              ),
            )
//            child: Text(
//              platformName,
//              style: TextStyle(
//                fontSize: 15.0,
////                fontStyle: FontStyle.italic,
//                color: Colors.white,
//                inherit: false,
//              ),
//            ),
          )
        ],
      ),
      onTap: () {
        if (type == 0) {
          print("share to wechat");
          fluwx.share(fluwx.WeChatShareWebPageModel(
              webPage: "https://www.baidu.com",
              title: "测试测试",
              description: "+++++++++++++++++++",
              thumbnail:
                  Constant.dirImage + "ShareApp_icon_WeChat friend@3x.png",
              scene: fluwx.WeChatScene.SESSION));
        } else if (type == 1) {
          print("share to circle");
          fluwx.share(fluwx.WeChatShareWebPageModel(
              webPage: "https://www.baidu.com",
              title: "测试测试",
              description: "+++++++++++++++++++",
              thumbnail:
                  Constant.dirImage + "ShareApp_icon_WeChat friend@3x.png",
              scene: fluwx.WeChatScene.TIMELINE));
        }
      },
    );
  }
}
