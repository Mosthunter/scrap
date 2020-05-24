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

class Showblock extends StatefulWidget {
  @override
  _ShowblockState createState() => _ShowblockState();
}

class _ShowblockState extends State<Showblock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Block'),
            onTap: () {
              _showdialogblock(context);
            },
          ),
        ),
      ),
    );
  }
}

void _showdialogblock(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            margin: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 20,
                left: a.width / 20,
                bottom: a.width / 5),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      width: a.width,
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: a.width / 20, bottom: a.width / 15),
                        width: a.width / 12,
                        height: a.width / 12,
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(a.width)),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff282828),
                      borderRadius: BorderRadius.circular(a.width / 50)),
                  width: a.width,
                  padding: EdgeInsets.all(a.width / 50),
                  height: a.height / 1.4,
                  child: Scaffold(
                    backgroundColor: Color(0xff282828),
                    body: Container(
                      width: a.width,
                      height: a.height,
                      padding: EdgeInsets.only(
                          top: a.width / 10, bottom: a.width / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.block,
                                color: Color(0xff8B8B8B),
                                size: a.width / 2.5,
                              ),
                              Text(
                                "บล๊อคผู้ใช้",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "คุณต้องการบล๊อคผู้ใช้รายนี้ไหม\nคุณจะไม่เห็นสแครปจากผู้ใช้รายนี้อีกต่อไป\nและผู้ใช้งานรายนี้จะไม่สามารถปาแครป\nหาคุณได้ด้วย",
                            style: TextStyle(
                                fontSize: a.width / 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: <Widget>[
                              RaisedButton(
                                  color: Color(0xff797979),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                  ),
                                  child: Container(
                                    width: a.width / 3.5,
                                    height: a.width / 8.5,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "บล๊อคจ่ะ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  onPressed: () {}),
                              Text(
                                '"แน่ใจนะ"',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
