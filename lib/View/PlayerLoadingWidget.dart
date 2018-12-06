import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'dart:io';

class LoadingWidget extends StatelessWidget {

  final bool isLoadding;

  LoadingWidget({this.isLoadding});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageWidth = 90.0;

    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          //  播放View
          color: Colors.white,
          margin: EdgeInsets.only(top: Platform.isAndroid ? 46.0 : 36.0),
          width: (screenHeight - 160) * 1.7,
          height: screenHeight - 160,
        ),

        Container(
//            alignment: AlignmentDirectional.bottomCenter,
            margin:
            EdgeInsets.only(top: 100.0, left: screenWidth / 4 - imageWidth / 2),
            width: imageWidth,
            height: imageWidth,
            child: Image.asset(Constant.dirImage + 'Loading.gif'),
        )
      ],
    );
//    return Offstage(
//      offstage: !isLoadding,
//      child: Container(
//        alignment: AlignmentDirectional.bottomCenter,
//        margin:
//        EdgeInsets.only(top: 100.0, left: screenWidth / 2 - imageWidth / 2),
//        width: imageWidth,
//        height: imageWidth,
//        child: Image.asset(
//          Constant.dirImage + 'Loading.gif',
//        ),
//      ),
//    );
  }
}
