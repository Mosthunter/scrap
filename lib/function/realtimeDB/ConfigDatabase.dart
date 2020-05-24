import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/RealtimeDB.dart';

class ConfigDateBase {
  final appIdIOS = '1:273076153449:ios:8f66f6fd8a254ee8fc46f8';
  final appIdAndroid = '1:273076153449:android:a07ee01f6c5c6466fc46f8';
  final apiKey = 'AIzaSyCf_SHTxMY2-QPgqdAe5vpdldrclAvYpoo';
  final gcm = '273076153449';
  bool isIOS = Platform.isIOS;

  Future<void> initRTDB(BuildContext context) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    db.scrapAll = await FirebaseApp.configure(
        name: 'scraps-all',
        options: firebaseOption(dbUrl: 'https://scraps-all.firebaseio.com/'));
    db.userTransact = await FirebaseApp.configure(
        name: 'user-transactions',
        options:
            firebaseOption(dbUrl: 'https://user-transactions.firebaseio.com/'));
  }

  FirebaseOptions firebaseOption({@required String dbUrl}) {
    return isIOS
        ? FirebaseOptions(
            googleAppID: appIdIOS,
            gcmSenderID: gcm,
            apiKey: apiKey,
            databaseURL: dbUrl,
          )
        : FirebaseOptions(
            googleAppID: appIdAndroid,
            apiKey: apiKey,
            databaseURL: dbUrl,
          );
  }
}

final confgiDB = ConfigDateBase();
