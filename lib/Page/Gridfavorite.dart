import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'dart:math' as math;

import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';

class Gridfavorite extends StatefulWidget {
  @override
  _GridfavoriteState createState() => _GridfavoriteState();
}

class _GridfavoriteState extends State<Gridfavorite> {
  List scraps = [];
  Map<String, List> history = {};
  bool loading = true;

  @override
  void initState() {
    initScrap();
    super.initState();
  }

  initScrap() async {
    scraps = await cacheHistory.readHistory(field: 'like') ?? [];
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    if (scraps.length > 1) {
      scraps.sort((a, b) =>
          DateTime.parse(a['when']).compareTo(DateTime.parse(b['when'])));
    }
    setState(() => loading = false);
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['time'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  ///0.000012
  ///0.000312
  Future<DataSnapshot> scrapTransaction(String docId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    return ref.once();
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  void dialog(int index) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Size a = MediaQuery.of(context).size;
      return StatefulBuilder(builder: (context, StateSetter setDialog) {
        Map doc = scraps[index];
        DocumentSnapshot docData;
        return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (a.width - a.width / 1.04) / 2),
                  width: a.width,
                  height: a.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: a.height / 42),
                        FutureBuilder(
                            future: Firestore.instance
                                .collection(doc['path'])
                                .document(doc['id'])
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                docData = data;
                                var scrap = data['scrap'];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            child: Image.asset(
                                              'assets/paper-readed.png',
                                              width: a.width / 1.04,
                                              height: a.width / 1.04 * 1.115,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 25, right: 25),
                                            height: a.width / 1.04 * 1.115,
                                            width: a.width / 1.04,
                                            child: Text(
                                              doc['text'],
                                              style: TextStyle(
                                                  height: 1.35, fontSize: s60),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: GestureDetector(
                                              child: Container(
                                                width: screenWidthDp / 16,
                                                height: screenWidthDp / 16,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff000000)
                                                        .withOpacity(0.47),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            screenWidthDp /
                                                                18)),
                                                child: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: s42),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      onDoubleTap: () {
                                        Scaffold.of(context).showBottomSheet(
                                          (context) => MapSheet(
                                            position: LatLng(
                                                data['position']['geopoint']
                                                    .latitude,
                                                data['position']['geopoint']
                                                    .longitude),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        );
                                      },
                                    ),
                                    SizedBox(height: screenWidthDp / 21),
                                    Container(
                                      width: a.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidthDp / 36),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                scrap['writer'] ==
                                                        'ไม่ระบุตัวตน'
                                                    ? 'ใครบางคน'
                                                    : '@${scrap['writer']}',
                                                style: TextStyle(
                                                    fontSize: s48,
                                                    height: 1.1,
                                                    color: scrap['writer'] ==
                                                            'ไม่ระบุตัวตน'
                                                        ? Colors.white
                                                        : Color(0xff26A4FF)),
                                              ),
                                              CountDownText(
                                                  startTime: data['scrap']
                                                          ['time']
                                                      .toDate())
                                            ],
                                          ),
                                          Icon(Icons.more_horiz,
                                              color: Colors.white, size: s70)
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      width: a.width / 1.04,
                                      height: a.width / 1.04 * 1.115,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/paper-readed.png'),
                                              fit: BoxFit.cover)),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    SizedBox(height: screenHeightDp / 12)
                                  ],
                                );
                              }
                            }),
                        SizedBox(height: screenWidthDp / 42),
                        Divider(color: Color(0xff5D5D5D), thickness: 1.2),
                        SizedBox(height: screenWidthDp / 46),
                        SizedBox(
                          width: a.width,
                          height: screenHeightDp / 9.6,
                          child: FutureBuilder(
                              future: scrapTransaction(doc['id']),
                              builder:
                                  (context, AsyncSnapshot<DataSnapshot> event) {
                                if (event.hasData) {
                                  var trans = event.data;
                                  var like = trans.value['like'];
                                  var pick = trans.value['picked'];
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setTrans) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: screenWidthDp / 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              GestureDetector(
                                                child: iconWithLabel(
                                                    like.abs().toString(),
                                                    icon: inHistory(
                                                            'like', doc['id'])
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    background: inHistory(
                                                            'like', doc['id'])
                                                        ? Color(0xffFF4343)
                                                        : Colors.white,
                                                    iconColor: inHistory(
                                                            'like', doc['id'])
                                                        ? Colors.white
                                                        : Color(0xffFF4343)),
                                                onTap: () {
                                                  if (docData != null) {
                                                    if (isExpired(docData)) {
                                                      scrap.toast(
                                                          'แสครปนี้ย่อยสลายแล้ว');
                                                    } else {
                                                      if (inHistory(
                                                          'like', doc['id'])) {
                                                        ++like;
                                                        history['like']
                                                            .remove(doc['id']);
                                                      } else {
                                                        --like;
                                                        history['like']
                                                            .add(doc['id']);
                                                      }
                                                      scrap.updateScrapTrans(
                                                          'like',
                                                          docData,
                                                          context,
                                                          comments: trans.value[
                                                              'comment']);

                                                      setTrans(() {});
                                                    }
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                child: iconWithLabel(
                                                    pick.abs().toString(),
                                                    background: inHistory(
                                                            'picked', doc['id'])
                                                        ? Color(0xff0099FF)
                                                        : Colors.white,
                                                    iconColor: inHistory(
                                                            'picked', doc['id'])
                                                        ? Colors.white
                                                        : Color(0xff0099FF),
                                                    icon: Icons.move_to_inbox),
                                                onTap: () {
                                                  if (docData != null) {
                                                    if (isExpired(docData)) {
                                                      scrap.toast(
                                                          'แสครปนี้ย่อยสลายแล้ว');
                                                    } else {
                                                      if (inHistory('picked',
                                                          doc['id'])) {
                                                        ++pick;
                                                        history['picked']
                                                            .remove(doc['id']);
                                                      } else {
                                                        --pick;
                                                        history['picked']
                                                            .add(doc['id']);
                                                      }
                                                      scrap.updateScrapTrans(
                                                          'picked',
                                                          docData,
                                                          context);
                                                      setTrans(() {});
                                                    }
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                  child: iconWithLabel(
                                                      trans?.value['comment']
                                                          .abs()
                                                          .toString(),
                                                      iconColor: Color(
                                                              0xff000000)
                                                          .withOpacity(0.83),
                                                      icon: Icons.sms),
                                                  onTap: () {
                                                    if (docData != null)
                                                      Scaffold.of(context)
                                                          .showBottomSheet(
                                                        (BuildContext
                                                                context) =>
                                                            CommentSheet(
                                                                scrapSnapshot:
                                                                    docData),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      );
                                                  })
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: screenWidthDp / 42),
                                          child: GestureDetector(
                                            child: iconWithLabel('ต่อไป',
                                                iconColor: Color(0xff000000),
                                                icon: Icons.forward),
                                            onTap: () {
                                              doc == scraps.last
                                                  ? index = 0
                                                  : ++index;
                                              print(index);
                                              setDialog(() {});
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  });
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                        ),
                        SizedBox(height: screenWidthDp / 36),
                        Expanded(
                          child: AdmobBanner(
                              adUnitId: AdmobService().getBannerAdId(),
                              adSize: AdmobBannerSize.FULL_BANNER),
                        )
                      ])),
            ));
      });
    }));
  }

  Widget iconWithLabel(String label,
      {Color background = Colors.white,
      @required Color iconColor,
      @required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: screenWidthDp / 9,
          width: screenWidthDp / 9,
          decoration: BoxDecoration(
              color: background, // Color(0xffFF4343),
              borderRadius: BorderRadius.circular(screenWidthDp / 8)),
          child: Icon(
            icon, // Icons.favorite_border,
            color: iconColor,
            size: s46,
          ),
        ),
        Text(
          label,
          style: TextStyle(
              color: Colors.white,
              fontSize: s42,
              height: 1.2,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: a.width,
              height: a.width / 5,
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: a.width / 20,
                    left: a.width / 30,
                    child: Container(
                      child: InkWell(
                        child: Container(
                            width: a.width / 15,
                            child: Image.asset(
                              "assets/Group 74.png",
                              //   fit: BoxFit.contain,
                              width: a.width / 12,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: a.width / 20,
                    left: a.width / 3.5,
                    child: Container(
                      child: Text(
                        'สแครปที่คุณติดตามในวันนี้',
                        style: TextStyle(
                            color: Colors.white, fontSize: a.width / 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            scraps.length > 0
                ? Container(
                    width: a.width,
                    height: a.height,
                    margin: EdgeInsets.only(top: a.width / 5.4),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Wrap(
                            spacing: a.width / 42,
                            runSpacing: a.width / 42,
                            alignment: WrapAlignment.center,
                            children:
                                scraps.map((scrap) => block(scrap)).toList()),
                        SizedBox(height: a.width / 5)
                      ],
                    ),
                  )
                : Container(
                    width: a.width,
                    height: a.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: appBarHeight / 10),
                            width: a.width / 3.2,
                            height: a.width / 3.2,
                            child: Icon(
                              Icons.favorite,
                              size: a.width / 6,
                              color: Color(0xfffFFFFFF).withOpacity(0.11),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff3C3C3C),
                                borderRadius: BorderRadius.circular(a.width)),
                          ),
                          SizedBox(height: a.width / 20),
                          text("คุณยังไม่ได้ติดตามสแครปในวันนี้"),
                          text("ลองกดหัวใจเพื่อดูการเคลื่อนไหว"),
                          text("ในสแครปที่คุณสนใจสิ")
                        ],
                      ),
                    )),
            Positioned(
              bottom: 0,
              child: AdmobBanner(
                  adUnitId: AdmobService().getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER),
            )
          ],
        ),
      ),
    );
  }

  Widget text(String textt) {
    Size a = MediaQuery.of(context).size;
    return Text(textt,
        style: TextStyle(
            color: Color(0xfffFFFFFF).withOpacity(0.51),
            fontWeight: FontWeight.bold,
            fontSize: a.width / 15));
  }

  Widget block(Map data) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    int ments;
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            height: 407 / a.width * 165,
            width: 365 / a.width * 165,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/paper-readed.png'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Text(
                data['text'],
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: FutureBuilder(
                  future:
                      scrapAll.reference().child('scraps/${data['id']}').once(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ments = snapshot.data.value['comment'];
                      return commentTransactionBox(
                          a, ments.abs(), data['comments'].abs());
                    } else {
                      return commentTransactionBox(
                          a, data['comments'].abs(), data['comments'].abs());
                    }
                  }))
        ],
      ),
      onTap: () {
        if (ments != null) {
          cacheHistory.updateFollowingScrap(data['id'], ments);
          scraps.firstWhere((scrap) => scrap['id'] == data['id'])['comments'] =
              ments;
          setState(() {});
          dialog(scraps.indexOf(data));
        }
      },
    );
  }

  Widget commentTransactionBox(Size a, int comments, int cacheComment) {
    return Container(
        margin: EdgeInsets.all(a.width / 45),
        alignment: Alignment.center,
        width: a.width / 5.5,
        height: a.width / 11,
        decoration: BoxDecoration(
            color: comments == cacheComment
                ? Color(0xff707070)
                : Color(0xff0077CC),
            borderRadius: BorderRadius.circular(a.width / 80)),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Text(
            '$comments',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: a.width / 20),
          ),
          Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(Icons.sms, color: Colors.white)),
          SizedBox(width: a.width / 64)
        ]));
  }
}
