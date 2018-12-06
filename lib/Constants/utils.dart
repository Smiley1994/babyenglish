import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:babyenglish/Constants/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

// md5 加密
String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}


//md5 bytes
List<int> binaryMd5(String data) {
  var content = Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  print(digest.bytes);
  return digest.bytes;
}


String abase64Url(String data) {
  var base64String = base64.encode(binaryMd5(data)).toString();
  base64String = base64String.replaceAll(RegExp(r"="), "");
  base64String = base64String.replaceAll(RegExp(r"\+"), "-");
  base64String = base64String.replaceAll(RegExp(r"/"), "_");
  return base64String;
}




final signatureTime = DateTime.now().millisecondsSinceEpoch * 2;

String tokenSignature(String data) {
  String tempString = "$signatureTime$data " + Constant.listSecret.toString();
  String signatureString = abase64Url(tempString);
  return signatureString;
}


save(String vipStatus) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(Constant.vipKey, vipStatus);
}

Future<String> getVipStatus() async {
  var vipStatus;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  vipStatus = prefs.getString(Constant.vipKey);
  return vipStatus;
}


Uri videoUri (String videoUrl) {
  Match match =
  RegExp(r"https://videos002.ann9.com(.+?)\?md5=(.+?)&expires=(.+)")
      .firstMatch(videoUrl);
  var urlPath = match.group(1).toString();
  var md5 = match.group(2).toString();
  var expires = match.group(3).toString();
  return Uri.https(
      "videos002.ann9.com", urlPath, {"md5": md5, "expires": expires});
}