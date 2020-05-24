import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class UserInfo {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userInfo.txt');
  }

  Future<bool> fileExist() async {
    final file = await _localFile;
    return file.exists();
  }

  // Future<bool> checkFileExist() async {
  //   if(!await fileExist()){
  //      var doc = await fireStore
  //       .collection('Users/${}/users')
  //       .document(user.uid)
  //       .get();
  //   }
  //   return (await fileExist());
  // }
  Future<void> initRegion({@required String region}) async {
    final file = await _localFile;
    Map userData = {'region': region};
    await file.writeAsString(json.encode(userData));
  }

  Future<void> initUserInfo({@required Map doc}) async {
    final file = await _localFile;
    String immPath = await storeImage(doc['img']);
    Map userData = {
      'img': immPath,
      'id': doc['id'],
      'status': doc['status'],
      'region': doc['region']
    };
    await file.writeAsString(json.encode(userData));
  }

  Future<Map> readContents() async {
    final file = await _localFile;
    Map data = json.decode(await file.readAsString());
    return data;
  }

  Future<void> editProImage(String newUrl) async {
    final file = await _localFile;
    var data = await readContents();
    data['img'] = newUrl;
    await file.writeAsString(json.encode(data));
  }

  Future<String> storeImage(String url) async {
    var response = await get(url);
    var documentDirectory = await _localPath;
    var filePathAndName = documentDirectory + '/propic.jpg';
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    return file2.uri.path;
  }

  Future<void> deleteFile() async {
    final file = await _localFile;
    var data = await readContents();
    await File(data['img']).delete();
    await file.delete();
  }
}

final userinfo = UserInfo();
