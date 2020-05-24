import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/realtimeDB/ConfigDatabase.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: HomePage());
  }
}
