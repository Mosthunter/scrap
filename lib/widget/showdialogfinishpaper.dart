import 'dart:ui';
import 'package:scrap/widget/Ads.dart';
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

class Showfinishpaper extends StatefulWidget {
  @override
  _ShowfinishpaperState createState() => _ShowfinishpaperState();
}

class _ShowfinishpaperState extends State<Showfinishpaper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Paper'),
            onTap: () {
              dialogfinishpaper(context);
            },
          ),
        ),
      ),
    );
  }
}

void dialogfinishpaper(BuildContext context) {
  showDialog(
      context: context,
      builder: (builder) {
        Size a = MediaQuery.of(context).size;
        return Scaffold(
          body: Container(
            width: a.width,
            height: a.height,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                //ADS here !!!!
                /*  Positioned(
                    bottom: 0,
                    child: AdmobBanner(
                        adUnitId: AdmobService().getBannerAdId(),
                        adSize: AdmobBannerSize.FULL_BANNER),
                  ),*/

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/allpaper.png",
                        width: a.width / 1.3,
                      ),
                      Container(
                        width: a.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: a.width / 12,
                            ),
                            Text(
                              "คุณได้รับการเติมกระดาษแล้ว",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 13,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: a.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                  width: a.width / 2.85,
                                  height: a.width / 7.3,
                                  //   margin: EdgeInsets.only(right: a.width / 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: a.width / 15,
                                          child: Image.asset(
                                            "assets/Group 74.png",
                                            color: Color(0xff26A4FF),
                                            fit: BoxFit.contain,
                                            //  width: a.width / 3 / 2,
                                          )),
                                      Text(
                                        "\tหน้าหลัก",
                                        style: TextStyle(
                                            color: Color(0xff26A4FF),
                                            fontSize: a.width / 15 / 1.2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(left: a.width / 20),
                                  width: a.width / 2.85,
                                  height: a.width / 7.3,
                                  decoration: BoxDecoration(
                                      color: Color(0xff26A4FF),
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.create,
                                        color: Colors.white,
                                        size: a.width / 15,
                                      ),
                                      Text("\tเขียนเลย",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 15 / 1.2,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
                                onTap: () {}),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      child: Ads(),
                    )),
              ],
            ),
          ),
        );
      });
}
