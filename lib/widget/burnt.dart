import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/friendList.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';
import 'package:scrap/widget/warning.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Burn extends StatefulWidget {
  @override
  _BurnState createState() => _BurnState();
}

class _BurnState extends State<Burn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Burn'),
            onTap: () {
              // _showdialogblock(context);
              _whatshot(context);
            },
          ),
        ),
      ),
    );
  }
}

void _whatshot(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: a.width,
                    height: a.height,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  width: a.width,
                  height: a.height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.whatshot,
                          size: a.width / 3,
                          color: Color(0xffFF8F3A),
                        ),
                        Text(
                          "สแครปนี้โดนเผาแล้ว !",
                          style: TextStyle(
                              fontSize: a.width / 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "ขอบคุณสำหรับการควบคุมเนื้อหา",
                          style: TextStyle(
                              fontSize: a.width / 17,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
