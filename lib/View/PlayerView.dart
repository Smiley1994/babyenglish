import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class PlayerWidget extends StatelessWidget {

  final bool isFullScreen;

  final VideoPlayerController playerController;

  final bool isPlaying;

  final GestureTapCallback ontop;

  PlayerWidget({this.isFullScreen, this.playerController, this.isPlaying, this.ontop});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double topPanding = 0.0;

    if (isFullScreen && Platform.isAndroid) {
      topPanding = 24.0;
    } else if (isFullScreen && Platform.isIOS) {
      topPanding = 0.0;
    } else {
      if (Platform.isAndroid) {
        topPanding = 46.0;
      } else if (Platform.isIOS) {
        topPanding = 36.0;
      }
    }

    return Container(
      //  播放View
        margin: EdgeInsets.only(top: topPanding),
        width: isFullScreen ? screenWidth : (screenHeight - 160) * 1.7,
        height: isFullScreen ? screenHeight : screenHeight - 160,
        child: Stack(
          children: <Widget>[
            Material(
              color: Colors.black,
              child: Scaffold(
                body: Center(
                  child: playerController.value.initialized
                      ? AspectRatio(
                    aspectRatio: playerController.value.aspectRatio,
                    child: VideoPlayer(playerController),
                  )
                      : Container(),
                ),
              ),
              borderRadius: BorderRadius.circular(isFullScreen ? 0.0 : 10.0),
            ),

            GestureDetector(
              child: Offstage(
                offstage: isFullScreen,
                child: Container(
                  margin: EdgeInsets.only(
                      left: 10.0,
                      top: isFullScreen
                          ? screenHeight - 80
                          : screenHeight - 220),
                  height: 46.0,
                  width: 46.0,
                  child: Image.asset(
                    playerController.value.isPlaying
                        ? Constant.dirImage + 'Playing_icon_suspend@2x.png'
                        : Constant.dirImage + "Playing_icon_play@2x.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: ontop,
            ),
          ],
        ));
  }
}