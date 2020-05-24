import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/Sorry.dart';
import 'package:scrap/Page/Update.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/Page/mainstream.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/realtimeDB/ConfigDatabase.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/ImgCacheManger.dart';
import 'package:scrap/services/jsonConverter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin messaging = FlutterLocalNotificationsPlugin();
  JsonConverter jsonConverter = JsonConverter();
  ImgCacheManager imgCacheManager = ImgCacheManager();
  DocumentSnapshot appInfo;
  initLocalMessage() {
    var android = AndroidInitializationSettings('noti_ic');
    var ios = IOSInitializationSettings();
    var initMessaging = InitializationSettings(android, ios);
    messaging.initialize(initMessaging, onSelectNotification: onTapMessage);
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          displayNotification(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          debugPrint('onLaunch');
          // displayNotification(message);
        },
        onResume: (Map<String, dynamic> message) async {
          debugPrint('onResume');
          // displayNotification(message);
        },
        onBackgroundMessage: Platform.isIOS ? null : Fcm.backgroundHandler);

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  displayNotification(Map message) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.scrap', 'scrap.', 'description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await messaging.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: '',
    );
  }

  Future onTapMessage(String payload) async {
    final auth = await FirebaseAuth.instance.currentUser();
    var uid = auth.uid;
    await Firestore.instance.collection('Users').document(uid).get().then(
        (data) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile())));
  }

  Future<bool> serverChecker() async {
    bool close;
    await Firestore.instance
        .collection('App')
        .document('info')
        .get()
        .then((doc) {
      close = doc.data['close'];
      appInfo = doc;
    });
    return false; //close && uid != 'czKPreN6fqVWJv2RaLSjzhKoAeV2';
  }

  bool olderVersion() {
    String recent = '1.1.0', incoming;
    bool isIOS = Platform.isIOS;
    isIOS
        ? incoming = appInfo['versions']['IOS']
        : incoming = appInfo['versions']['android'];
    return false; // recent != incoming;
  }

  Future<bool> isNotLogin() async {
    await confgiDB.initRTDB(context);
    final user = Provider.of<UserData>(context, listen: false);
    final auth = await FirebaseAuth.instance.currentUser();
    if (auth != null) user.uid = auth.uid;
    return auth == null;
  }

  Future<bool> finishProfile() async {
    final user = Provider.of<UserData>(context, listen: false);
    var map = await userinfo.readContents();
    user.region = map['region'];
    if (map['img'] == null) {
      var doc = await fireStore
          .collection('Users/${map['region']}/users')
          .document(user.uid)
          .get();
      if (doc.exists && doc['img'] != null) {
        var map = doc.data;
        doc.data['region'] = user.region;
        await userinfo.initUserInfo(doc: map);
        return true;
      } else
        return false;
    } else
      return true;
  }

  @override
  void initState() {
    initFirebaseMessaging();
    initLocalMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
        color: Colors.black,
        child: InkWell(
          child: Container(
            width: a.width / 2,
            height: a.width / 5,
            child: SplashScreen.callback(
              name: 'assets/splash.flr',
              startAnimation: 'Untitled',
              onSuccess: (data) async {
                await serverChecker()
                    ? navigator(Sorry())
                    : olderVersion()
                        ? navigator(Update())
                        : await isNotLogin()
                            ? navigator(LoginPage())
                            : await finishProfile()
                                ? navigator(MainStream())
                                : navigator(CreateProfile1());
              },
              loopAnimation: '1',
              until: () => Future.delayed(Duration(seconds: 1)),
              endAnimation: '0',
              onError: (e, er) {
                print(e);
                print(er);
              },
            ),
          ),
        ));
  }

  navigator(var where) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => where));
  }
}

class Fcm {
  static Future<dynamic> backgroundHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      debugPrint('DatabackgroundHandler');
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      debugPrint('NotibackgroundHandler');
    }

    // Or do other work.
  }
}
