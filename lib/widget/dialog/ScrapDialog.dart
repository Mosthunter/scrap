import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';

class ScrapDialog extends StatefulWidget {
  final DocumentSnapshot data;
  final bool showTransaction;
  final bool self;
  final List currentList;
  ScrapDialog(
      {@required this.data,
      this.self = false,
      this.showTransaction = true,
      this.currentList});
  @override
  _ScrapDialogState createState() => _ScrapDialogState();
}

class _ScrapDialogState extends State<ScrapDialog> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, List> history = {};

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  Future<DataSnapshot> scrapTransaction(String docId) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    return ref.once();
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: (screenWidthDp - screenWidthDp / 1.04) / 2),
          width: screenWidthDp,
          height: screenHeightDp,
          child: FutureBuilder(
              future: scrapTransaction(widget.data.documentID),
              builder: (context, event) {
                if (event.hasData && event.data?.value != null) {
                  var trans = event.data;
                  var like = trans.value['like'];
                  var pick = trans.value['picked'];
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: screenHeightDp / 42),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: screenWidthDp / 1.04,
                                    height: screenWidthDp / 1.04 * 1.115,
                                    child: SvgPicture.asset(
                                        'assets/${texture.textures[widget.data['scrap']['texture'] ?? 0]}',
                                        fit: BoxFit.cover),
                                    //  child: Image.asset('assets/paperscrap.jpg'),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.only(left: 25, right: 25),
                                    height: screenWidthDp / 1.04 * 1.115,
                                    width: screenWidthDp / 1.04,
                                    child: Text(
                                      widget.data['scrap']['text'],
                                      style: TextStyle(
                                        height: 1.35,
                                        fontSize: s60,
                                      ),
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
                                            borderRadius: BorderRadius.circular(
                                                screenWidthDp / 18)),
                                        child: Icon(Icons.close,
                                            color: Colors.white, size: s42),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              onDoubleTap: () {
                                showDialog(
                                  context: _scaffoldKey.currentState.context,
                                  builder: (BuildContext context) => MapSheet(
                                    position: LatLng(
                                        widget.data['position']['geopoint']
                                            .latitude,
                                        widget.data['position']['geopoint']
                                            .longitude),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: screenWidthDp / 21),
                            Container(
                              width: screenWidthDp,
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
                                        widget.data['scrap']['writer'] ==
                                                'ไม่ระบุตัวตน'
                                            ? 'ใครบางคน'
                                            : '@${widget.data['scrap']['writer']}',
                                        style: TextStyle(
                                            fontSize: s48,
                                            height: 1.1,
                                            color: widget.data['scrap']
                                                        ['writer'] ==
                                                    'ไม่ระบุตัวตน'
                                                ? Colors.white
                                                : Color(0xff26A4FF)),
                                      ),
                                      CountDownText(
                                          startTime: widget.data['scrap']
                                                  ['timeStamp']
                                              .toDate())
                                    ],
                                  ),
                                  widget.self
                                      ? GestureDetector(
                                          child: Icon(Icons.more_horiz,
                                              color: Colors.white, size: s70),
                                          onTap: () => showMore(context,
                                              writerUid: widget.data['uid']))
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidthDp / 42),
                        Divider(color: Color(0xff5D5D5D), thickness: 1.2),
                        SizedBox(height: screenWidthDp / 46),
                        SizedBox(
                          width: screenWidthDp,
                          height: screenHeightDp / 9.6,
                          child:
                              // counter.count == adsRate
                              //     ? Center(
                              //         child: GestureDetector(
                              //             child: iconWithLabel('ต่อไป',
                              //                 iconColor: Color(0xff000000),
                              //                 icon: Icons.forward),
                              //             onTap: () {
                              //               randomAdsRate();
                              //               counter.count = 0;
                              //               setDialog(() {});
                              //             }))
                              //     :

                              !widget.showTransaction
                                  ? SizedBox()
                                  : StatefulBuilder(
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
                                                  child: iconfrommilla(
                                                      inHistory(
                                                              'like',
                                                              widget.data
                                                                  .documentID)
                                                          ? 'assets/heart-fill-icon.svg'
                                                          : 'assets/heart-icon.svg',
                                                      like.abs().toString(),
                                                      iconColor: inHistory(
                                                              'like',
                                                              widget.data
                                                                  .documentID)
                                                          ? Colors.white
                                                          : Colors.red,
                                                      backgroundColor: inHistory(
                                                              'like',
                                                              widget.data
                                                                  .documentID)
                                                          ? Colors.red
                                                          : Colors.white),
                                                  onTap: () {
                                                    if (isExpired(
                                                        widget.data)) {
                                                      toast.toast(
                                                          'สเเครปนี้ย่อยสลายแล้ว');
                                                    } else {
                                                      scrap.updateScrapTrans(
                                                          'like',
                                                          doc: widget.data);
                                                      if (inHistory(
                                                          'like',
                                                          widget.data
                                                              .documentID)) {
                                                        ++like;
                                                        history['like'].remove(
                                                            widget.data
                                                                .documentID);
                                                      } else {
                                                        --like;
                                                        history['like'].add(
                                                            widget.data
                                                                .documentID);
                                                      }
                                                      setTrans(() {});
                                                    }
                                                  },
                                                ),
                                                GestureDetector(
                                                  child: iconfrommilla(
                                                      inHistory(
                                                              'picked',
                                                              widget.data
                                                                  .documentID)
                                                          ? 'assets/keep-icon.svg'
                                                          : 'assets/keep-icon.svg',
                                                      pick.abs().toString(),
                                                      iconColor: inHistory(
                                                              'picked',
                                                              widget.data
                                                                  .documentID)
                                                          ? Colors.blue
                                                          : Colors.white,
                                                      backgroundColor: inHistory(
                                                              'picked',
                                                              widget.data
                                                                  .documentID)
                                                          ? Colors.white
                                                          : Colors.blue),
                                                  // child: iconWithLabel(
                                                  //     pick.abs().toString(),
                                                  //     background: inHistory(
                                                  //             'picked',
                                                  //             widget.data
                                                  //                 .documentID)
                                                  //         ? Color(0xff0099FF)
                                                  //         : Colors.white,
                                                  //     iconColor: inHistory(
                                                  //             'picked',
                                                  //             widget.data
                                                  //                 .documentID)
                                                  //         ? Colors.white
                                                  //         : Color(0xff0099FF),
                                                  //     icon:
                                                  //         Icons.move_to_inbox),
                                                  onTap: () {
                                                    if (isExpired(
                                                        widget.data)) {
                                                      toast.toast(
                                                          'สเเครปนี้ย่อยสลายแล้ว');
                                                    } else {
                                                      scrap.updateScrapTrans(
                                                          'picked',
                                                          doc: widget.data,
                                                          comments: trans.value[
                                                              'comment']);
                                                      if (inHistory(
                                                          'picked',
                                                          widget.data
                                                              .documentID)) {
                                                        ++pick;
                                                        history['picked']
                                                            .remove(widget.data
                                                                .documentID);
                                                      } else {
                                                        --pick;
                                                        history['picked'].add(
                                                            widget.data
                                                                .documentID);
                                                      }
                                                      setTrans(() {});
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
                                                    Scaffold.of(context)
                                                        .showBottomSheet(
                                                      (BuildContext context) =>
                                                          CommentSheet(
                                                              doc: widget.data),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                        ),
                        SizedBox(height: screenWidthDp / 36),
                        // Expanded(
                        //   child: AdmobBanner(
                        //       adUnitId: AdmobService().getBannerAdId(),
                        //       adSize: AdmobBannerSize.FULL_BANNER),
                        // )
                      ]);
                } else if (event.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.only(top: screenHeightDp / 42),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: screenWidthDp / 1.04,
                          height: screenWidthDp / 1.04 * 1.115,
                          child: SvgPicture.asset(
                              'assets/${texture.textures[widget.data['scrap']['texture'] ?? 0]}',
                              height: screenWidthDp / 2.16 * 1.21,
                              width: screenWidthDp / 2.16,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            child: Container(
                              width: screenWidthDp / 16,
                              height: screenWidthDp / 16,
                              decoration: BoxDecoration(
                                  color: Color(0xff000000).withOpacity(0.47),
                                  borderRadius: BorderRadius.circular(
                                      screenWidthDp / 18)),
                              child: Icon(Icons.close,
                                  color: Colors.white, size: s42),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Center(child: LoadNoBlur())
                      ],
                    ),
                  );
                } else {
                  return burntScrap();
                }
              }),
        )));
  }

  Widget burntScrap() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: screenHeightDp / 42),
            child: Stack(
              children: <Widget>[
                Container(
                    width: screenWidthDp / 1.04,
                    height: screenWidthDp / 1.04 * 1.115,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/paperscrap.jpg'),
                            fit: BoxFit.cover)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.2, sigmaY: 3.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.whatshot,
                              size: screenWidthDp / 3,
                              color: Color(0xffFF8F3A)),
                          Text("สแครปนี้โดนเผาแล้ว !",
                              style: TextStyle(
                                  fontSize: s54,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    child: Container(
                      width: screenWidthDp / 16,
                      height: screenWidthDp / 16,
                      decoration: BoxDecoration(
                          color: Color(0xff000000).withOpacity(0.47),
                          borderRadius:
                              BorderRadius.circular(screenWidthDp / 18)),
                      child: Icon(Icons.close, color: Colors.white, size: s42),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: screenWidthDp / 21),
          SizedBox(height: screenWidthDp / 42),
          Divider(color: Color(0xff5D5D5D), thickness: 1.2),
          SizedBox(height: screenWidthDp / 46),
          Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'กระดาษแผ่นนี้ถูกเผาแล้ว🔥',
                    style: TextStyle(color: Colors.white, fontSize: s46),
                  ),
                ],
              )),
          SizedBox(height: screenWidthDp / 36),
          Expanded(
            child: AdmobBanner(
                adUnitId: AdmobService().getBannerAdId(),
                adSize: AdmobBannerSize.FULL_BANNER),
          )
        ]);
  }

  Widget iconfrommilla(
    String asset,
    String label, {
    //Color background = Colors.white,
    @required Color iconColor,
    @required Color backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(screenWidthDp / 40),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(screenWidthDp)),
          //  child:
          child: SvgPicture.asset(
            asset,
            color: iconColor,
            height: screenWidthDp / 15,
            width: screenWidthDp / 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(
              color: Color(0xffff5f5f5),
              fontSize: s42,
              height: 1.2,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  // Widget burntScrap({@required Function onNext}) {
  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Container(
  //           margin: EdgeInsets.only(top: screenHeightDp / 42),
  //           child: Stack(
  //             children: <Widget>[
  //               Container(
  //                   width: screenWidthDp / 1.04,
  //                   height: screenWidthDp / 1.04 * 1.115,
  //                   decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                           image: AssetImage('assets/paperscrap.jpg'),
  //                           fit: BoxFit.cover)),
  //                   child: BackdropFilter(
  //                     filter: ImageFilter.blur(sigmaX: 3.2, sigmaY: 3.2),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         Icon(Icons.whatshot,
  //                             size: screenWidthDp / 3,
  //                             color: Color(0xffFF8F3A)),
  //                         Text("สแครปนี้โดนเผาแล้ว !",
  //                             style: TextStyle(
  //                                 fontSize: s54,
  //                                 color: Colors.black87,
  //                                 fontWeight: FontWeight.bold)),
  //                       ],
  //                     ),
  //                   )),
  //               Positioned(
  //                 top: 12,
  //                 right: 12,
  //                 child: GestureDetector(
  //                   child: Container(
  //                     width: screenWidthDp / 16,
  //                     height: screenWidthDp / 16,
  //                     decoration: BoxDecoration(
  //                         color: Color(0xff000000).withOpacity(0.47),
  //                         borderRadius:
  //                             BorderRadius.circular(screenWidthDp / 18)),
  //                     child: Icon(Icons.close, color: Colors.white, size: s42),
  //                   ),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: screenWidthDp / 21),
  //         SizedBox(height: screenWidthDp / 42),
  //         Divider(color: Color(0xff5D5D5D), thickness: 1.2),
  //         SizedBox(height: screenWidthDp / 46),
  //         Container(
  //             padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 36),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: <Widget>[
  //                 Text(
  //                   'กระดาษแผ่นนี้ถูกเผาแล้ว🔥',
  //                   style: TextStyle(color: Colors.white, fontSize: s46),
  //                 ),
  //                 GestureDetector(
  //                   child: iconWithLabel('ต่อไป',
  //                       iconColor: Color(0xff000000), icon: Icons.forward),
  //                   onTap: onNext,
  //                 ),
  //               ],
  //             )),
  //         SizedBox(height: screenWidthDp / 36),
  //         Expanded(
  //           child: AdmobBanner(
  //               adUnitId: AdmobService().getBannerAdId(),
  //               adSize: AdmobBannerSize.FULL_BANNER),
  //         )
  //       ]);
  // }

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
              color: background,
              borderRadius: BorderRadius.circular(screenWidthDp / 8)),
          child: Icon(icon, color: iconColor, size: s46),
        ),
        Text(label,
            style: TextStyle(
                color: Colors.white,
                fontSize: s42,
                height: 1.2,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  void showMore(context, {@required String writerUid}) {
    final user = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: appBarHeight * 2.2,
            decoration: BoxDecoration(
              color: Color(0xff202020),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 12, bottom: 4),
                      width: screenWidthDp / 3.2,
                      height: screenHeightDp / 81,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeightDp / 42),
                        color: Color(0xff929292),
                      ),
                    )),
                Container(
                  // margin: EdgeInsets.only(
                  //   bottom: appBarHeight - 20,
                  // ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenWidthDp / 12,
                            ),
                            GestureDetector(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Icon(Icons.delete_outline,
                                      size: appBarHeight / 3)),
                              onTap: () async {
                                final db = Provider.of<RealtimeDB>(context,
                                    listen: false);
                                var userDb =
                                    FirebaseDatabase(app: db.userTransact);
                                var ref = userDb
                                    .reference()
                                    .child('users/${user.uid}');
                                var trans = await ref.child('pick').once();
                                ref.update({'pick': trans.value - 1});
                                cacheHistory.removeHistory(
                                    'picked', widget.data.documentID);
                                widget.currentList.remove(widget.data);
                                await fireStore
                                    .collection(
                                        'Users/${user.region}/users/${user.uid}/scrapCollection')
                                    .document(widget.data.documentID)
                                    .delete();
                                nav.pop(context);
                                nav.pop(context);
                                toast.toast('นำสแครปนี้ออกแล้ว');
                              },
                            ),
                            Text(
                              'นำออก',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: s42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenWidthDp / 12,
                            ),
                            GestureDetector(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Icon(Icons.report_problem,
                                      size: appBarHeight / 3)),
                              onTap: () {
                                final report =
                                    Provider.of<Report>(context, listen: false);
                                report.targetId = writerUid;
                                nav.pop(context);
                                showDialogReport(context);
                              },
                            ),
                            Text(
                              'รายงาน',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: s42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //     bottom: 0,
                //     child: Container(
                //       child: AdmobBanner(
                //           adUnitId: AdmobService().getBannerAdId(),
                //           adSize: AdmobBannerSize.FULL_BANNER),
                //     )),
              ],
            ),
          );
        });
  }
}
