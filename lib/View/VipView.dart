import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'package:babyenglish/Weidget_common/push_animation.dart';
import 'package:babyenglish/Constrller/VipPaymentViewController.dart';
//import 'package:video_player/video_player.dart';

class VipWidget extends StatelessWidget {
  final bool offstage;
  final double topPadding;
  VipWidget({this.offstage, this.topPadding});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

//    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
//    VideoPlayerController _playerController;
//    playerListener() {
//      if (_playerController.value.duration == null ||
//          _playerController.value.position == null) {
//        return;
//      } else if (_playerController.value.duration.inSeconds ==
//          _playerController.value.position.inSeconds) {
//        _playerController.pause();
//      }
//    }

//    _playerController = VideoPlayerController.network(
//        "https://videos002.ann9.com/kids/videos/jjd-BeTX6U0.mp4?md5=1f6xB--LU4GLoTIYP8DbXw&expires=3080882013000")
//      ..addListener(playerListener())
//      ..initialize().then((_) {
//    });

//    if (offstage == false) {
//      _playerController.play();
//      print("paly status is " + offstage.toString());
//    } else {
//
//      _playerController.pause();
//      print("paly status is " + offstage.toString());
//    }
    return Offstage(
      offstage: offstage,
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: topPadding, left: 15.0, bottom: 10.0),
                width: screenWidth / 3 + 15,
//                height: screenHeight,
                child: Image.asset(
                  Constant.dirImage + "Vip_Background@3x.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      AnimationPageRoute(
                          slideTween: Tween<Offset>(
                              begin: Offset(0.0, 0.0), end: Offset.zero),
                          builder: (c) {
                            return VipPaymentControl();
                          }));
                },
                child: Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  margin: EdgeInsets.only(left: 45.0, bottom: 27.0),
                  width: screenWidth / 3 - 40,
                  child: Image.asset(
                    Constant.dirImage + "Vip_Button_Open members@2x.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
            ],
          ),

          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: topPadding + 2, left: 15.0, bottom: 17.0),
                width: screenWidth - screenWidth / 3 - 60,
                child: Image.asset(
                  Constant.dirImage + "VipSample.jpg",
                  fit: BoxFit.fitHeight,
                ),
                color: Colors.white70,
//                child: _playerController.value.initialized
//                    ? AspectRatio(
//                  aspectRatio: _playerController.value.aspectRatio,
//                  child: VideoPlayer(_playerController),
//                )
//                    : Container(
//                  color: Colors.white,
//                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//class VipWidget extends StatefulWidget {
//
//  final bool offstage;
//  final double topPadding;
//
//  VipWidget({@required this.offstage, this.topPadding});
//
//
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return VipViewState(offstage: offstage, topPadding: topPadding);
//  }
//}
//
//class VipViewState extends State<VipWidget> with SingleTickerProviderStateMixin {
//
//  bool offstage;
//  final double topPadding;
//
//  VipViewState({@required this.offstage, this.topPadding});
//  @override
//  Widget build(BuildContext context) {
//
////    print(offstage);
//    setState(() {
//      offstage = !offstage;
//    });
//    final screenWidth = MediaQuery.of(context).size.width;
//    // TODO: implement buil
//    return Offstage(
//      offstage: offstage,
//      child: Row(
//        children: <Widget>[
//          Stack(
//            children: <Widget>[
//              Container(
//                margin:
//                EdgeInsets.only(top: topPadding, left: 15.0, bottom: 10.0),
//                width: screenWidth / 3 + 15,
////                height: screenHeight,
//                child: Image.asset(
//                  Constant.dirImage + "Vip_Background@3x.png",
//                  fit: BoxFit.fitWidth,
//                ),
//              ),
//              GestureDetector(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      AnimationPageRoute(
//                          slideTween: Tween<Offset>(
//                              begin: Offset(0.0, 0.0), end: Offset.zero),
//                          builder: (c) {
//                            return VipPaymentControl();
//                          }));
//                },
//                child: Container(
//                  alignment: AlignmentDirectional.bottomCenter,
//                  margin: EdgeInsets.only(left: 45.0, bottom: 27.0),
//                  width: screenWidth / 3 - 40,
//                  child: Image.asset(
//                    Constant.dirImage + "Vip_Button_Open members@2x.png",
//                    fit: BoxFit.fitHeight,
//                  ),
//                ),
//              )
//            ],
//          ),
//          Stack(
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(
//                    top: topPadding + 2, left: 15.0, bottom: 17.0),
//                width: screenWidth - screenWidth / 3 - 60,
//                color: Colors.red,
////                child: Image.asset(
////                  Constant.dirImage + 'BabyLearnEnglish_Background.png',
////                  fit: BoxFit.fitWidth,
////                ),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
