import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:babyenglish/Constants/api_url.dart';
import 'dart:convert';
import 'package:babyenglish/Constants/utils.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class VipPaymentControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VipPaymentControlState();
  }
}

class VipPaymentControlState extends State<VipPaymentControl>
    with SingleTickerProviderStateMixin {
  String vipType = "1001";
  var data;

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final screenHeight = MediaQuery.of(context).size.height;
//    final screenWidth = MediaQuery.of(context).size.width;

    double topPanding = 0.0;
    if (Platform.isAndroid) {
      topPanding = 36.0;
    } else if (Platform.isIOS) {
      topPanding = 30.0;
    }

    GestureDetector buildMoneyButtons(String imageName, int type) {
      double widgetWidth = 180.0;
      return GestureDetector(
        child: Container(
            width: widgetWidth,
            child: Stack(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    Constant.dirImage + imageName,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            )),
        onTap: () {
          if (type == 0) {

            setState(() {
              vipType = "1001";
            });
          } else if (type == 1) {

            setState(() {
              vipType = "1002";
            });
          } else if (type == 2) {

            setState(() {
              vipType = "1003";
            });
          }
        },
      );
    }

    return Stack(
//      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            Constant.dirImage + "BabyLearnEnglish_Background.png",
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          // 返回按钮
          onTap: () {
            if (vipType != Constant.isVip) {
              vipType = Constant.notVip;
            }
            Navigator.pop(context,vipType);
          },
          child: Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.only(top: topPanding, left: 17.0),
            height: 36.0,
            width: 36.0,
            child: Image.asset(
              Constant.dirImage + "Playing_icon_Return@3x.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          alignment: AlignmentDirectional.topStart,
          margin: EdgeInsets.only(top: topPanding + 1.5, left: 70.0),
          height: 30.0,
//          width: 36.0,
          child: Image.asset(
            Constant.dirImage + "OpenUp.png",
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: topPanding + 75, left: 0.0, right: 0.0),
          alignment: AlignmentDirectional.topCenter,
          width: double.infinity,
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildMoneyButtons(vipType == "1001" ? "image:3x:1month_selected.png" : "image:3x:1month_normal.png", 0),
              buildMoneyButtons(vipType == "1002" ? "image:3x:3month_selected.png" : "image:3x:3month_normal.png", 1),
              buildMoneyButtons(vipType == "1003" ? "image:3x:12month_selected.png" : "image:3x:12month_normal.png", 2)
            ],
          ),
        ),
//
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(
              bottom: 25.0,
              top: screenHeight - 75,
            ),
            alignment: AlignmentDirectional.bottomCenter,
            child: Image.asset(
              Constant.dirImage + "OpenVipButton.png",
//          fit: BoxFit.fitHeight,
            ),
          ),
          onTap: () {
            payment();
          },
        ),
      ],
    );
  }

  payment() async {
    print(vipType.toString());
    Dio().post(Api.vipPayUrl, data: {"PayType": vipType}).then((response) {
      if (response.data != null) {
        Map<String, dynamic> map = json.decode(response.data);
        callwechat(map["data"]);
      }
    });
  }

  callwechat(Map<String, dynamic> data) {
    fluwx
        .pay(
            appId: Constant.wechatAppId,
            partnerId: data["mch_id"],
            prepayId: data["prepay_id"],
            packageValue: "Sign=WXPay",
            nonceStr: data["nonce_str"],
            timeStamp: data["timestamp"],
            sign: data["sign"])
        .then((response) {

    });

    fluwx.responseFromPayment.listen((response) {
      //do something
      if (response.errCode == 0) {
        print("success");
        save(Constant.isVip);
        vipType = Constant.isVip;
      }  else {
        print("failed");
        vipType = Constant.notVip;
      }
//      print("type>>>>>>>>>>>>${response.type}");
//      print("androidOpenId>>>>>>>>>>>>${response.androidOpenId}");
//      print("iOSDescription>>>>>>>>>>>>${response.iOSDescription}");
//      print("androidPrepayId>>>>>>>>>>>>${response.androidPrepayId}");
//      print("extData>>>>>>>>>>>>${response.extData}");
//      print("androidTransaction>>>>>>>>>>>>${response.androidTransaction}");
//      print("errStr>>>>>>>>>>>>${response.errStr}");
//      print("errCode>>>>>>>>>>>>${response.errCode}");

    });
  }

}

//class VipTypeWidget extends StatelessWidget {
////  int position;
//  bool visible = false;
//  VipTypeWidget({this.visible});
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
////    final screenHeight = MediaQuery.of(context).size.height;
////    final screenWidth = MediaQuery.of(context).size.width;
//    return Container(
//      margin: EdgeInsets.only(left: 230 - 70.0, top: 90.0),
//      width: 40.0,
//      child: Offstage(
//        offstage: visible,
//        child: Image.asset(
//          Constant.dirImage + "Select_Price.png",
//          fit: BoxFit.fitHeight,
//        ),
//      ),
//    );
//  }
//}
