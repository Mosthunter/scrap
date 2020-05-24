import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class JsonConverter {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/friends.txt');
  }

  Future<File> get _localFriendList async {
    final path = await _localPath;
    return File('$path/friendList.txt');
  }

  Future<File> writeContent({@required List listm, List friends}) async {
    final file = await _localFile;
    if (friends != null) {
      final list = await _localFriendList;
      // Write the file
      list.writeAsString(json.encode(friends));
    }
    return file.writeAsString(json.encode(listm));
  }

  Future<List> updateContent(
      {@required String id,
      @required String imgUrl,
      @required String joinD,
      @required int index}) async {
    try {
      List<Map> list = await readContents();
      list.replaceRange(index, ++index, [
        {'img': imgUrl, 'id': id, 'join': joinD}
      ]);
      await writeContent(listm: list);
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> searchContents({@required String id}) async {
    try {
      final file = await _localFile;
      List<Map> listm = [];
      // Read the fil
      String contents = await file.readAsString();
      json
          .decode(contents)
          .forEach((map) => map['id'].contains(id) ? listm.add(map) : null);
      return listm;
    } catch (e) {
      // If there is an error reading, return a default String
      return [];
    }
  }

  Future<List> readContents() async {
    try {
      final file = await _localFile;
      List<Map> listm = [];
      // Read the fil
      String contents = await file.readAsString();
      json.decode(contents).forEach((map) => listm.add(map));
      return listm;
    } catch (e) {
      // If there is an error reading, return a default String
      return [];
    }
  }

  Future<List> readFriendList() async {
    final fileFriend = await _localFriendList;
    List friendList = json.decode(await fileFriend.readAsString());
    return friendList ?? [];
  }

  Future<List> addContent(
      {String uid, String id, String imgUrl, String joinD}) async {
    try {
      final fileFriend = await _localFriendList;
      List friendList = json.decode(await fileFriend.readAsString());
      List<Map> list = await readContents();
      friendList.add(uid);
      list.add({'img': imgUrl, 'id': id, 'join': joinD});
      await writeContent(listm: list, friends: friendList);
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> removeContent({String uid, String key, String where}) async {
    try {
      List<Map> list = await readContents();
      final fileFriend = await _localFriendList;
      List friendList = json.decode(await fileFriend.readAsString());
      friendList.remove(uid);
      list.removeWhere((data) => data[key] == where);
      await writeContent(listm: list, friends: friendList);
      return list;
    } catch (e) {
      return [];
    }
  }
}

final jsonConv = JsonConverter();
