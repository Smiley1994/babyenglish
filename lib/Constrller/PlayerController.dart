import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'package:babyenglish/Constants/utils.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:babyenglish/Constants/api_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:babyenglish/View/PlayerView.dart';
import 'package:babyenglish/View/PlayerLoadingWidget.dart';
import 'package:babyenglish/Constrller/VipPaymentViewController.dart';
//import 'package:babyenglish/Weidget_common/push_animation.dart';
import 'dart:async';
//import 'package:path_provider/path_provider.dart';

class PlayerControl extends StatefulWidget {
  final model;
  final video;
  final String remoteAddr;
  final int point;
  PlayerControl(
      {Key key, @required this.model, this.video, this.remoteAddr, this.point})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print(
        "model === $model, \n video ==== $video, \n remoteAddr ===== $remoteAddr  \n point ===== $point");
    return PlayerControlState(
        model: model, video: video, remoteAddr: remoteAddr, point: point);
  }
}

class PlayerControlState extends State<PlayerControl>
    with SingleTickerProviderStateMixin {
  String downVideoImage = Constant.dirImage + "Playing_icon_Next@3x.png";
  String upVideoImage = Constant.dirImage + "Playing_icon_The last@3x.png";
  bool isFullScreen = false;

  var model; // 传过来的视频信息
  var video;
  String remoteAddr;
  int point;
  int currentItem = 0;

  List listData = List();
  var curPage = 0;
  var listTotalSize = 0;
  ScrollController _scrollController = ScrollController();

  PlayerControlState(
      {@required this.model, this.video, this.remoteAddr, this.point}) {
    curPage = point;
    _scrollController.addListener(scrollViewControllerListener);
  }

  scrollViewControllerListener() {
    var maxScroll = _scrollController.position.maxScrollExtent;
    var pixels = _scrollController.position.pixels;
    if (maxScroll == pixels && listData.length < listTotalSize - 10) {
      curPage += 60;
      loadVideoList(true);
    }
  }

  String videoUrl(String path, String videoId, String addr, String domain) {
    String tempPath = path.replaceAll(RegExp(r"{id}"), videoId);
    String tempString = signatureTime.toString() +
        tempPath.toString() +
        addr +
        ' ' +
        Constant.videoSecret.toString();
    String signatureString = abase64Url(tempString);
    String videoUrl =
        domain + '$tempPath?md5=$signatureString&expires=$signatureTime';
    return videoUrl;
  }

  VideoPlayerController _playerController;
  bool _isPlaying = false;
  String vipStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future<String> status = getVipStatus();
    status.then((sampleString) {
      sampleString == null
          ? vipStatus = Constant.notVip
          : vipStatus = sampleString;
    });

    loadVideoList(false);
    String videoUrlSTring = videoUrl(video['path'].toString(),
        model['id'].toString(), remoteAddr, video['domain'].toString());
    switchVideo(videoUrlSTring);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollViewControllerListener);
    if (_playerController != null) {
      _playerController.removeListener(playerListener);
    }

    super.dispose();
  }

  switchVideo(String videoUrl) {
    print(videoUrl);
    if (_playerController != null) {
      killPlayerViewController();
    }

    temptationVideoPath(videoUrl);
  }


  // 测试视频连接
  http.Client client = new http.Client();
  temptationVideoPath(String videoUrl) async {
    try {
      http.Request request = new http.Request("GET", videoUri(videoUrl)); // create get request
      http.StreamedResponse response = await http.Client()
          .send(request); // sends request and waits for response stream
      if (response.statusCode == 200) {
        print("status:" + response.statusCode.toString());
        loadingVideo(videoUrl);
      } else {
        print("${response.statusCode}....视频连接失败.....");
      }
    } on TimeoutException catch (e) {
      print("time out ==== $e");
      rethrow;
    } catch (e) {
      loadingVideo(videoUrl);
      print("other ==== $e");
      rethrow;
    } finally {
      print(">>>>>>>>>>CLOSE");
      client?.close();
    }
//    client.close();
//    var toByte = new StreamTransformer<List<int>, Uint8List>.fromHandlers(
//        handleData: (data, sink) {
//      sink.add(data);
//    });
//    intTempVideoLength = 0;
//    isPlaying = false;
//    http.Request request = new http.Request("GET", url); // create get request
//    http.StreamedResponse response = await http.Client()
//        .send(request); // sends request and waits for response stream
//    if (response.statusCode == 200) {
//      print("status:" + response.statusCode.toString());
//      loadingVideo(url.toString());
//    } else {
//      print("${response.statusCode}....视频连接失败.....");
//    }
//    response.stream.transform(toByte).listen((value) {
//      intTempVideoLength += value.length;
//      save(value);

//      Future<File> file = get();
//      file.then((File file) {
//        print(file.path);
//      });
//      print(
//          "intTempVideoLength:$intTempVideoLength,listen((value):${value.length}");
//      if (isPlaying == false) {
//        Future<File> file = get();
//        file.then((File file) {
//          if (intTempVideoLength > 1024 * 1024 * 3) {
//            isPlaying = true;
//            print("_playerController playing:${file.path}");
//            _playerController = VideoPlayerController.file(
//              file,
//            )
//              ..addListener(playerListener)
//              ..initialize().then((_) {
//                setState(() {
//                  _playerController.play();
//                });
//              });
//            setState(() {});
//          }
//        });
//      } else {
//        print("_playerController playing");
//      }
//    }
//    );
  }

  loadingVideo(String videoUrl) {
    _playerController = VideoPlayerController.network(
      videoUrl,
    )
      ..addListener(playerListener)
      ..initialize().then((_) {
        setState(() {
          _playerController.play();
        });
      });
    setState(() {});
  }

  playerListener() {
    automaticallyPlay();
    if (_playerController != null) {
      if (_isPlaying != _playerController.value.isPlaying) {
        setState(() {
          _isPlaying = _playerController.value.isPlaying;
        });
      }
    }
  }

  automaticallyPlay() {
    if (_playerController != null) {
      if (_playerController.value.duration == null ||
          _playerController.value.position == null) {
        return;
      } else if (_playerController.value.duration.inSeconds ==
          _playerController.value.position.inSeconds) {
        print("==========");
        if (currentItem < listData.length) {
          var listItem = listData[currentItem += 1];
          String videoPath = videoUrl(
              video['path'].toString(),
              listItem['id'].toString(),
              remoteAddr,
              video['domain'].toString());
          switchVideo(videoPath);
        } else {
          killPlayerViewController();
        }
      } else if (_playerController.value.position.inSeconds > 10 &&
          vipStatus == Constant.notVip) {
        _playerController.removeListener(playerListener);
        _playerController.pause();
        openPaymentVipController();
      }
    }
  }

  killPlayerViewController () {
    _playerController.removeListener(playerListener);
    _playerController.pause();
    _playerController = null;
  }

  openPaymentVipController() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new VipPaymentControl()),
    );
    vipStatus = result.toString();
    print(vipStatus);
  }

  loadVideoList(bool isLoadMore) {
    var data = '{"offset":$curPage,"limit":200}';
    Dio()
        .request(
      Api.freeVideoList,
      data: data,
      options: Options(method: 'POST', headers: {
        "Content-Type": "application/json",
        "SToken": tokenSignature(data),
        "SExpires": "$signatureTime"
      }),
    )
        .then((response) {
      if (response.data != null) {
        Map<String, dynamic> map = json.decode(response.data);
        if (map["status"] == 1) {
          remoteAddr = response.headers['X-RemoteAddr'][0].toString();
          video = map['data']['video'];
          listTotalSize = map['data']['total'];
          List _listData = map['data']['rows'];
          setState(() {
            if (!isLoadMore) {
              listData = _listData;
            } else {
              listData.addAll(_listData);
            }
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double topPanding = 0.0;
    if (Platform.isAndroid) {
      topPanding = 36.0;
    } else if (Platform.isIOS) {
      topPanding = 26.0;
    }
    // TODO: implement build
    if (listData == null) {
      return Container(
        // 背景
        width: screenWidth,
        height: screenHeight,
        child: Image.asset(
          Constant.dirImage + "Play_Interface_Background@3x.png",
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            // 背景
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              Constant.dirImage + "Play_Interface_Background@3x.png",
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            // 返回按钮
            onTap: () {
              if (_playerController != null) {
                _playerController.pause();
                _playerController = null;
              }
              Navigator.pop(context);
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
//          GestureDetector(
//            // 投屏按钮
//            onTap: () {
//              if (Platform.isAndroid) {
//                print("android");
//              } else if (Platform.isIOS) {
//                print('iOS');
//              }
//            },
//            child: Container(
//              alignment: AlignmentDirectional.topStart,
//              margin:
//                  EdgeInsets.only(top: topPanding, left: screenWidth - 70.0),
//              height: 36.0,
//              width: 36.0,
//              child: Image.asset(
//                Constant.dirImage + "Playing_icon_Castscreen@3x.png",
//                fit: BoxFit.cover,
//              ),
//            ),
//          ),
          Container(
            alignment: AlignmentDirectional.bottomCenter,
            margin: EdgeInsets.only(
                top: screenHeight - 100, bottom: 5.0, left: 15.0, right: 15.0),
            width: double.infinity - 40.0,
            height: 80.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listData.length,
                controller: _scrollController,
                itemBuilder: (context, i) {
                  return _buildRow(i);
                }),
          ),
          GestureDetector(
            // 上一集
            onTapDown: (TapDownDetails down) {
              setState(() {
                upVideoImage = Constant.dirImage + "Left_Button@3x.png";
              });
            },
            onTapUp: (TapUpDetails up) {
              setState(() {
                upVideoImage =
                    Constant.dirImage + "Playing_icon_The last@3x.png";
              });
            },
            onTap: () {
              if (currentItem > 0) {
                var listItem = listData[currentItem -= 1];
                String videoPath = videoUrl(
                    video['path'].toString(),
                    listItem['id'].toString(),
                    remoteAddr,
                    video['domain'].toString());
                switchVideo(videoPath);
              } else {
                print("已经是第一个视频了....");
              }
            },
            child: Container(
              alignment: AlignmentDirectional.topCenter,
              margin: EdgeInsets.only(top: screenHeight / 3 + 15, left: 25.0),
              height: 36.0,
              width: 36.0,
              child: Image.asset(
                upVideoImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            // 下一集
            onTapDown: (TapDownDetails down) {
              setState(() {
                downVideoImage = Constant.dirImage + "right_Button@3x.png";
              });
            },
            onTapUp: (TapUpDetails up) {
              setState(() {
                downVideoImage = Constant.dirImage + "Playing_icon_Next@3x.png";
              });
            },
            onTap: () {
              if (currentItem < listData.length) {
                _playerController.pause();
                var listItem = listData[currentItem += 1];
                String videoPath = videoUrl(
                    video['path'].toString(),
                    listItem['id'].toString(),
                    remoteAddr,
                    video['domain'].toString());
                _playerController.removeListener(playerListener);
                switchVideo(videoPath);
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: screenHeight / 3 + 15, left: screenWidth - 70.0),
              height: 36.0,
              width: 36.0,
              child: Image.asset(
                downVideoImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  isFullScreen = !isFullScreen;
                  setState(() {});
                },
                child: _playerController != null
                    ? PlayerWidget(
                        isFullScreen: isFullScreen,
                        playerController: _playerController,
                        isPlaying: _isPlaying,
                        ontop: () {
                          _playerController.value.isPlaying
                              ? _playerController.pause()
                              : _playerController.play();

                          _playerController.value.isPlaying
                              ? _playerController.addListener(playerListener)
                              : _playerController
                                  .removeListener(playerListener);
                        },
                      )
                    : LoadingWidget(),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildRow(index) {
    var itemData = listData[index];
    return GestureDetector(
      onTap: () {
        if (currentItem == index) {
          print("========");
//          if (_playerController != null) {
//            _playerController.pause();
//          }
          return;
        } else {
          currentItem = index;
          if (_playerController != null) {
            killPlayerViewController();
          }
          String videoPath = videoUrl(
              video['path'].toString(),
              itemData['id'].toString(),
              remoteAddr,
              video['domain'].toString());
          switchVideo(videoPath);
        }
      },
      child: Container(
          width: index == currentItem ? 80.0 * 1.35 : 65 * 1.35,
          decoration: index == currentItem
              ? BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.lightBlue),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(10.0)))
              : BoxDecoration(),
          margin: const EdgeInsets.all(3.0),
          child: CachedNetworkImage(
            imageUrl: itemData["cover"].toString(),
            placeholder: Image.asset(
              Constant.dirImage + "Loading.gif",
              fit: BoxFit.fitWidth,
            ),
          )),
    );
  }
}
