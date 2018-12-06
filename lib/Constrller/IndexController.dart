import 'package:flutter/material.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'package:babyenglish/Constants/utils.dart';
import 'package:babyenglish/Weidget_common/push_animation.dart';
import 'package:babyenglish/Constrller/PlayerController.dart';
import "package:dio/dio.dart";
import 'package:babyenglish/Constants/api_url.dart';
import 'dart:convert';
import 'package:babyenglish/View/VipView.dart';
import 'package:babyenglish/View/ShareView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

//import 'dart:typed_data';

class IndexControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IndexConstrolState();
  }
}

class IndexConstrolState extends State<IndexControl>
    with SingleTickerProviderStateMixin {
  int selectedItem = 0;
  bool offstageOfVip = true;
  bool offstageOfShare = true;
  double topPadding = 110.0;

  List listData;
  var video;
  String remoteaddr;

  var curPage = 0;
  var listTotalSize = 0;
  ScrollController _controller = ScrollController();

  IndexConstrolState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

//      print(listData.length.toInt());
////      print(listTotalSize);
      if (maxScroll == pixels && listData.length < listTotalSize) {
        print(maxScroll.toInt());
        print(pixels.toInt());
        curPage += 100;
        loadVideoList(true);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVideoList(false);
  }

  final nowTime = DateTime.now().millisecondsSinceEpoch * 2;

  String signature(String data) {
    String tempString = "$nowTime$data " + Constant.listSecret.toString();
    String signatureString = abase64Url(tempString);
    return signatureString;
  }

  Dio dio = Dio();

  loadVideoList(bool isLoadMore) {
    var data = '{"offset":$curPage,"limit":100}';
    try {
      dio
          .post(
        Api.freeVideoList,
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            "Content-Type": "application/json",
            "SToken": signature(data),
            "SExpires": "$nowTime"
          },
          connectTimeout: 10000,
          receiveTimeout: 10000,
        ),
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        print(111111);

      }).then((response) {
        if (response != null) {
          Map<String, dynamic> map = json.decode(response.data);
          if (map["status"] == 1) {
            remoteaddr = response.headers['X-RemoteAddr'][0].toString();
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
    } on TimeoutException catch (e) {
      print("time out ==== $e");
      rethrow;
    } catch (e) {
      print("other ==== $e");
      rethrow;
    } finally {
      print(">>>>>>>>>>CLOSE");
      dio.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    GestureDetector buildTopButtons(String imageName, int type) {
      return GestureDetector(
        child: Container(
          width: 60.0,
          child: Image.asset(
            Constant.dirImage + imageName,
            fit: BoxFit.fitHeight,
          ),
        ),
        onTap: () {
          if (type == 0) {
            setState(() {
              selectedItem = 0;
              offstageOfVip = true;
              offstageOfShare = true;
            });
          } else if (type == 1) {
            setState(() {
              selectedItem == 1 ? selectedItem = 0 : selectedItem = 1;
              offstageOfVip = !offstageOfVip;
              if (offstageOfShare == false) {
                offstageOfShare = true;
              }
            });
          } else if (type == 2) {
            setState(() {
              selectedItem == 2 ? selectedItem = 0 : selectedItem = 2;
              offstageOfShare = !offstageOfShare;
              if (offstageOfVip == false) {
                offstageOfVip = true;
              }
            });
          }
        },
      );
    }

    if (listData == null) {
      return Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                Constant.dirImage + 'BabyLearnEnglish_Background.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              height: 140.0,
              width: 140.0,
              child: Image.asset(
                Constant.dirImage + 'Loading.gif',
              ),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              Constant.dirImage + "BabyLearnEnglish_Background.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            alignment: AlignmentDirectional.topCenter,
            height: 100.0,
            width: 130.0 * 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildTopButtons(
                    selectedItem == 0
                        ? "icons:3x:list_selected.png"
                        : "icons:3x:list_normal.png",
                    0),
                buildTopButtons(
                    selectedItem == 1
                        ? "icons:3x:vip_selected.png"
                        : "icons:3x:vip_normal.png",
                    1),
                buildTopButtons(
                    selectedItem == 2
                        ? "icons:3x:share_selected.png"
                        : "icons:3x:share_normal.png",
                    2),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: 20.0, top: 115.0, left: 20.0, right: 20.0),
            width: double.infinity - 40.0,
            height: double.infinity - 80.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listData.length,
              itemBuilder: (context, i) => _buildRow(i),
              controller: _controller,
            ),
          ),
          VipWidget(
            offstage: offstageOfVip,
            topPadding: topPadding,
          ),
          ShareWidget(
            visible: offstageOfShare,
          )
        ],
      );
    }
  }

  http.Client client = new http.Client();
  Future<String> testNetwork(Uri url, String index) async {
    http.Request request = new http.Request("GET", url); // create get request
    http.StreamedResponse response = await client
        .send(request); // sends request and waits for response stream
//    print("response:" + response.headers.toString());
    print("${index}status:----->" + response.statusCode.toString());
//    client.close();
    return response.statusCode.toString();
  }

  Widget _buildRow(index) {
    var itemData = listData[index];

//    Match match = RegExp(r"https://videos002.ann9.com:876(.+)")
//        .firstMatch(itemData["cover"].toString());
//    var urlPath = match.group(1).toString();
//    testNetwork(Uri.https("videos002.ann9.com:876", urlPath), index.toString());

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            AnimationPageRoute(
                slideTween:
                    Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset.zero),
                builder: (c) {
                  return PlayerControl(
                    model: listData[index],
                    video: video,
                    remoteAddr: remoteaddr,
                    point: index,
                  );
                }));
      },

      child: Container(
        width: 280.0,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: itemData["cover"],
          placeholder: Image.asset(
            Constant.dirImage + "Loading.gif",
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
//      chi
    );
  }
}
