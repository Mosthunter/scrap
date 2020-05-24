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

class Showcontract extends StatefulWidget {
  @override
  _ShowcontractState createState() => _ShowcontractState();
}

class _ShowcontractState extends State<Showcontract> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
            child: InkWell(
          child: Text('Contract'),
          onTap: () {
            dialogcontract(context);
          },
        )),
      ),
    );
  }
}

void dialogcontract(context) {
  int ass = 0;
  showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size a = MediaQuery.of(context).size;
          screenutilInit(context);
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              margin: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 20,
                left: a.width / 20,
              ),
              child: Column(
                children: <Widget>[
                  Container(
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
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xff282828),
                          borderRadius: BorderRadius.circular(a.width / 50)),
                      width: a.width,
                      padding: EdgeInsets.all(a.width / 50),
                      height: a.height / 1.5,
                      child: Scaffold(
                          backgroundColor: Color(0xff282828),
                          body: Column(
                            children: <Widget>[
                              Container(
                                width: a.width,
                                height: a.width / 8,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: a.width / 1000,
                                            color: Colors.grey))),
                                child: Text(
                                  "สัญญากับเรา",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: a.width / 15,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(a.width / 25),
                                child: SizedBox(
                                  width: a.width,
                                  child: Text(
                                    "เพื่อสร้างชุมชนที่ดีขึ้นของสแครป คุณสัญญาว่าจะไม่ทำสิ่งเหล่านี้\n\n1.กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย\n2.ส่งข้อความสแปมไปยังผู้ใช้รายอื่น\n3.เขียนเนื้อหาที่ส่งเสริมความรุนแรง\n4.เขียนเนื้อหาที่มีการคุกคามทางเพศ\n\n* หากคณไม่ทำตามสัญญาดังกล่าวสแครปขอ อนุญาติให้ความร่วมมือกับหบ่วยงานทางกฎหมายมากเท่าที่เราจะทำได้",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: a.width / 20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: appBarHeight / 2,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    appBarHeight / 2,
                                    appBarHeight / 22,
                                    appBarHeight / 2,
                                    appBarHeight / 22),
                                decoration: BoxDecoration(
                                    color: Color(0xfff27A4FF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(23))),
                                child: GestureDetector(
                                  child: Text(
                                    'สัญญา',
                                    style: TextStyle(
                                        color: Color(0xfffFFFFFF),
                                        fontSize: s52,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          );
        });
      });
}
