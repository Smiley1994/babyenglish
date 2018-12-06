import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';


Future<String> get _localPath async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/temp2.mp4');
}

save(value) async {
  final file = await _localFile;

  file.writeAsBytes(value, mode: FileMode.append, flush: true);
}

delete() async {
  final file = await _localFile;
  file.deleteSync(recursive: false);
}

Future<File> get() async {
  final file = await _localFile;
  return file;
}
//  Future<List<int>> get() async {
//    final file = await _localFile;
//    return file.readAsBytes();
//  }