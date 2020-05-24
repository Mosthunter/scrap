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
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';
import 'package:scrap/widget/warning.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Announce extends StatefulWidget {
  @override
  _AnnounceState createState() => _AnnounceState();
}
String publisher = "test";
String content = "test2";

class _AnnounceState extends State<Announce> {
 callAnnouncement() async {
    await Firestore.instance
    .collection("App")
    .document("info")
    .collection("Announcement")
    .getDocuments()
    .then((allDoc){
      allDoc.documents.forEach((doc) { 
        publisher = doc.data['publisher'];
        content = doc.data['content'];
        setState(() {
        });
      });
    });
  }
  @override
  void initState() {
    callAnnouncement();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: InkWell(
                child: Text('announce'),
                onTap: () {
                  _showdialogannounce(context);
                })));
  }
}

void _showdialogannounce(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(
                  top: a.width / 4,
                  right: a.width / 20,
                  left: a.width / 20,
                  bottom: a.width / 5),
              child: Column(
                children: <Widget>[
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
                            top: a.width / 5, bottom: a.width / 10),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              '$publisher',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20 * 1.2,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: appBarHeight,
                              child: Container(),
                            ),
                            Text(
                              content,
                              style: TextStyle(
                                  fontSize: a.width / 25 * 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            RaisedButton(
                                color: Color(0xffFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(a.width),
                                ),
                                child: Container(
                                  width: a.width / 4,
                                  height: a.width / 8,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "เข้าสู่แอป",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: a.width / 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onPressed: () {
                                  // _whatshot(context);
                                }),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
