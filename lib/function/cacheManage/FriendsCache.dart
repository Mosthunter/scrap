import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FriendsCache {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/friends.txt');
  }

  Future<void> intitFile() async {
    final file = await _localFile;
    Map userData = {'following': [], 'recently': {}};
    await file.writeAsString(json.encode(userData));
  }

  Future<Map> read() async {
    final file = await _localFile;
    var data = json.decode(await file.readAsString());
    return data;
  }

  Future<void> addFollowing({@required List following}) async {
    final file = await _localFile;
    var data = await read();
    data['following'].addAll(following);
    await file.writeAsString(json.encode(data));
  }
}

final cacheFriends = FriendsCache();
