import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/scrapFilter.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/AdsCounter.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/dialog/WatchVideoDialog.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/thrown.dart';

class MapScraps extends StatefulWidget {
  final String uid;
  MapScraps({@required this.uid});
  @override
  _MapScrapsState createState() => _MapScrapsState();
}

class _MapScrapsState extends State<MapScraps> {
  final geoLocator = Geolocator();
  final random = Random();
  Position currentLocation;
  StreamSubscription subLimit;
  int adsRate = 0;
  int i = 0, papers;
  PublishSubject<int> streamLimit = PublishSubject();
  DocumentSnapshot recentScrap;
  List<DocumentSnapshot> allScrap = [];
  bool loadFin = false;
  BitmapDescriptor _curcon, scrapIcon;
  bool checkPlatform = Platform.isIOS;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  GoogleMapController mapController;
  Set ads = {};
  Map randData = {};
  Map<String, List> history = {};
  Scraps scrap = Scraps();
  final infoKey = GlobalKey();
  ScrapFilter filter = ScrapFilter();
  StreamSubscription streamLocation;

  @override
  void initState() {
    streamLocation == null
        ? streamLocation = geoLocator
            .getPositionStream()
            .listen((event) => setState(() => currentLocation = event))
        : streamLocation.resume();
    randomAdsRate();
    initUserHistory();
    super.initState();
  }

  void randomAdsRate() {
    adsRate = 3;
    adsRate += random.nextInt(2) + 1;
  }

  Future<void> initUserHistory() async {
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    setState(() => loadFin = true);
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  Future<DataSnapshot> scrapTransaction(String docId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    return ref.once();
  }

  error(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "ขออภัย",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['time'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  void dialog(DocumentSnapshot doc) {
    final counter = Provider.of<AdsCounterProvider>(context, listen: false);
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    var data = doc;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Size a = MediaQuery.of(context).size;
      return StatefulBuilder(builder: (context, StateSetter setDialog) {
        return Scaffold(
            key: _scaffoldKey,
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
                        counter.count == adsRate
                            ? Center(
                                child: Text(
                                'โฆษณา',
                                style: TextStyle(
                                    fontSize: s42,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))
                            : SizedBox(height: a.height / 42),
                        counter.count == adsRate
                            ? SizedBox(
                                width: a.width / 1.04,
                                height: a.width / 1.04 * 1.29,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: a.width / 1.04,
                                      height: a.width / 1.04 * 1.29,
                                      child: AdmobBanner(
                                          adUnitId:
                                              AdmobService().getBannerAdId(),
                                          adSize: AdmobBannerSize.FULL_BANNER),
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
                                                          screenWidthDp / 18)),
                                              child: Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: s42),
                                            ),
                                            onTap: () {
                                              randomAdsRate();
                                              counter.count = 0;
                                              Navigator.pop(context);
                                            }))
                                  ],
                                ),
                              )
                            : Column(
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
                                            data['scrap']['text'],
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidthDp / 18)),
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
                                      _scaffoldKey.currentState.showBottomSheet(
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
                                              data['scrap']['user'] ==
                                                      'ไม่ระบุตัวตน'
                                                  ? 'ใครบางคน'
                                                  : '@${data['scrap']['user']}',
                                              style: TextStyle(
                                                  fontSize: s48,
                                                  height: 1.1,
                                                  color: data['scrap']
                                                              ['user'] ==
                                                          'ไม่ระบุตัวตน'
                                                      ? Colors.white
                                                      : Color(0xff26A4FF)),
                                            ),
                                            CountDownText(
                                                startTime: data['scrap']['time']
                                                    .toDate())
                                          ],
                                        ),
                                        Icon(Icons.more_horiz,
                                            color: Colors.white, size: s70)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: screenWidthDp / 42),
                        Divider(color: Color(0xff5D5D5D), thickness: 1.2),
                        SizedBox(height: screenWidthDp / 46),
                        SizedBox(
                          width: a.width,
                          height: screenHeightDp / 9.6,
                          child: counter.count == adsRate
                              ? Center(
                                  child: GestureDetector(
                                      child: iconWithLabel('ต่อไป',
                                          iconColor: Color(0xff000000),
                                          icon: Icons.forward),
                                      onTap: () {
                                        randomAdsRate();
                                        counter.count = 0;
                                        setDialog(() {});
                                      }))
                              : FutureBuilder(
                                  future: scrapTransaction(data.documentID),
                                  builder: (context,
                                      AsyncSnapshot<DataSnapshot> event) {
                                    if (event.hasData) {
                                      var trans = event.data;
                                      var like = trans.value['like'];
                                      var pick = trans.value['picked'];
                                      return StatefulBuilder(builder:
                                          (context, StateSetter setTrans) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: screenWidthDp / 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: iconWithLabel(
                                                        like.abs().toString(),
                                                        icon: inHistory('like',
                                                                data.documentID)
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        background: inHistory(
                                                                'like',
                                                                data.documentID)
                                                            ? Color(0xffFF4343)
                                                            : Colors.white,
                                                        iconColor: inHistory(
                                                                'like',
                                                                data.documentID)
                                                            ? Colors.white
                                                            : Color(
                                                                0xffFF4343)),
                                                    onTap: () {
                                                      if (isExpired(data)) {
                                                        scrap.toast(
                                                            'แสครปนี้ย่อยสลายแล้ว');
                                                      } else {
                                                        scrap.updateScrapTrans(
                                                            'like',
                                                            data,
                                                            context,
                                                            comments:
                                                                trans.value[
                                                                    'comment']);
                                                        if (inHistory('like',
                                                            data.documentID)) {
                                                          ++like;
                                                          history['like']
                                                              .remove(data
                                                                  .documentID);
                                                        } else {
                                                          --like;
                                                          history['like'].add(
                                                              data.documentID);
                                                        }
                                                        setTrans(() {});
                                                      }
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: iconWithLabel(
                                                        pick.abs().toString(),
                                                        background: inHistory(
                                                                'picked',
                                                                data.documentID)
                                                            ? Color(0xff0099FF)
                                                            : Colors.white,
                                                        iconColor: inHistory(
                                                                'picked',
                                                                data.documentID)
                                                            ? Colors.white
                                                            : Color(0xff0099FF),
                                                        icon: Icons
                                                            .move_to_inbox),
                                                    onTap: () {
                                                      if (isExpired(data)) {
                                                        scrap.toast(
                                                            'แสครปนี้ย่อยสลายแล้ว');
                                                      } else {
                                                        scrap.updateScrapTrans(
                                                            'picked',
                                                            data,
                                                            context);
                                                        if (inHistory('picked',
                                                            data.documentID)) {
                                                          ++pick;
                                                          history['picked']
                                                              .remove(data
                                                                  .documentID);
                                                        } else {
                                                          --pick;
                                                          history['picked'].add(
                                                              data.documentID);
                                                        }
                                                        setTrans(() {});
                                                      }
                                                      // if (inHistory('picked',
                                                      //     data.documentID)) {
                                                      //   ++pick;
                                                      //   history['picked']
                                                      //       .remove(data
                                                      //           .documentID);
                                                      // } else {
                                                      //   --pick;
                                                      //   history['picked'].add(
                                                      //       data.documentID);
                                                      // }
                                                      // scrap.updateScrapTrans(
                                                      //     'picked',
                                                      //     data,
                                                      //     context);
                                                      // setTrans(() {});
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
                                                        (BuildContext
                                                                context) =>
                                                            CommentSheet(
                                                                scrapSnapshot:
                                                                    data),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      );
                                                    },
                                                  )
                                                  // Container(
                                                  //   decoration: BoxDecoration(
                                                  //       color: Colors.white,
                                                  //       borderRadius: BorderRadius.circular(a.width)),
                                                  //   child: Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                                  //     children: <Widget>[
                                                  //       writer != 'สุ่มโดย Scrap'
                                                  //           ? InkWell(
                                                  //               child: Container(
                                                  //                 margin: EdgeInsets.only(
                                                  //                     right: a.width / 42),
                                                  //                 width: a.width / 6,
                                                  //                 height: a.width / 6,
                                                  //                 child: Column(
                                                  //                     mainAxisAlignment:
                                                  //                         MainAxisAlignment.center,
                                                  //                     children: <Widget>[
                                                  //                       Icon(
                                                  //                         Icons.whatshot,
                                                  //                         color: Colors.grey[600],
                                                  //                         size: a.width / 14,
                                                  //                       ),
                                                  //                       Text(
                                                  //                         "เผา",
                                                  //                         style: TextStyle(
                                                  //                             color: Colors.grey[600],
                                                  //                             fontSize: a.width / 25),
                                                  //                       )
                                                  //                     ]),
                                                  //               ),
                                                  //               onTap: () async {
                                                  //                 await burn(id);
                                                  //                 Navigator.pop(context);
                                                  //                 Taoast().toast('คุณได้เผากระดาษไปแล้ว');
                                                  //               },
                                                  //             )
                                                  //           : SizedBox(),
                                                  //       InkWell(
                                                  //         child: Container(
                                                  //           margin: EdgeInsets.only(right: a.width / 40),
                                                  //           width: a.width / 6,
                                                  //           height: a.width / 6,
                                                  //           child: Column(
                                                  //               mainAxisAlignment:
                                                  //                   MainAxisAlignment.center,
                                                  //               children: <Widget>[
                                                  //                 Image.asset('assets/garbage_grey.png',
                                                  //                     width: a.width / 14,
                                                  //                     height: a.width / 14,
                                                  //                     fit: BoxFit.cover),
                                                  //                 Text(
                                                  //                   "ทิ้งไว้",
                                                  //                   style: TextStyle(
                                                  //                       color: Colors.grey[600],
                                                  //                       fontSize: a.width / 25),
                                                  //                 )
                                                  //               ]),
                                                  //         ),
                                                  //         onTap: () {
                                                  //           Navigator.pop(context);
                                                  //         },
                                                  //       ),
                                                  //       InkWell(
                                                  //         child: Container(
                                                  //           width: a.width / 6,
                                                  //           height: a.width / 6,
                                                  //           child: Column(
                                                  //               mainAxisAlignment:
                                                  //                   MainAxisAlignment.center,
                                                  //               children: <Widget>[
                                                  //                 Icon(
                                                  //                   Icons.save_alt,
                                                  //                   color: Colors.grey[600],
                                                  //                   size: a.width / 14,
                                                  //                 ),
                                                  //                 Text(
                                                  //                   "เก็บไว้",
                                                  //                   style: TextStyle(
                                                  //                       color: Colors.grey[600],
                                                  //                       fontSize: a.width / 25),
                                                  //                 )
                                                  //               ]),
                                                  //         ),
                                                  //         onTap: () async {
                                                  //           Navigator.pop(context);
                                                  //           await pickScrap(
                                                  //               id, text, '$time $date', writer);
                                                  //         },
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: screenWidthDp / 42),
                                              child: GestureDetector(
                                                child: iconWithLabel('ต่อไป',
                                                    iconColor:
                                                        Color(0xff000000),
                                                    icon: Icons.forward),
                                                onTap: () {
                                                  counter.count += 1;
                                                  allScrap.remove(data);
                                                  markers.remove(MarkerId(
                                                      data.documentID));
                                                  if (allScrap.isNotEmpty &&
                                                      allScrap.length > 0) {
                                                    setDialog(() =>
                                                        data = allScrap.first);
                                                    streamLimit.add(
                                                        16 - allScrap.length);
                                                  } else {
                                                    Taoast()
                                                        .toast('กระดาษหมดแล้ว');
                                                  }
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

  burn(String scrapID) async {
    // await Firestore.instance
    //     .collection('Scraps')
    //     .document('hatyai')
    //     .collection('scrapsPosition')
    //     .document(scrapID)
    //     .updateData({
    //   'burned': FieldValue.arrayUnion([widget.uid])
    // });
    //change this structure
  }

  @override
  dispose() {
    subLimit?.cancel();
    streamLocation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    _createMarkerImageFromAsset(context);
    _createScrapImageFromAsset(context);
    screenutilInit(context);
    return currentLocation == null
        ? gpsCheck(a, 'กรุณาตรวจสอบ GPS ของคุณ')
        : Scaffold(
            backgroundColor: Colors.grey[900],
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey[900],
                  width: a.width,
                  height: a.height,
                  child: loadFin
                      ? GoogleMap(
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          onMapCreated: onMapCreated,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation?.latitude ?? 0,
                                  currentLocation?.longitude ?? 0),
                              zoom: 18.5,
                              tilt: 90),
                          markers: Set<Marker>.of(markers.values),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                Positioned(bottom: 0, child: bottomButton())
                //  Positioned(left: -56, bottom: a.height / 3.6, child: slider())
              ],
            ));
  }

  Widget bottomButton() {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return Container(
        padding: EdgeInsets.only(bottom: screenWidthDp / 10),
        alignment: Alignment.bottomCenter,
        width: screenWidthDp,
        height: screenHeightDp / 1.1,
        child: Container(
          margin: EdgeInsets.only(
              left: screenWidthDp / 80, right: screenWidthDp / 80),
          child: StreamBuilder(
            stream:
                userDb.reference().child('users/${widget.uid}/papers').onValue,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                papers = snapshot.data.snapshot?.value ?? 15;
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => user.papers = snapshot.data.snapshot?.value ?? 15);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            screenWidthDp / 24,
                            screenWidthDp / 36,
                            screenWidthDp / 24,
                            screenWidthDp / 36),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                spreadRadius: 3.0,
                                offset: Offset(0.0, 3.2),
                              )
                            ],
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(screenWidthDp / 14.2)),
                        child: papers < 1
                            ? Text(
                                'กระดาษของคุณหมดแล้ว',
                                style: TextStyle(
                                    fontSize: screenWidthDp / 18,
                                    color: Colors.white),
                              )
                            : Row(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize: screenWidthDp / 18,
                                          color: Colors.white,
                                          fontFamily: 'ThaiSans'),
                                      children: <TextSpan>[
                                        TextSpan(text: ' เหลือกระดาษ '),
                                        TextSpan(
                                            text: '$papers',
                                            style: TextStyle(
                                                fontSize: screenWidthDp / 16,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text: ' แผ่น',
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ),
                      onTap: () {
                        papers == 15
                            ? scrap.toast('กระดาษของคุณยังเต็มอยู่')
                            : dialogvideo(context, widget.uid);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Gridsubscripe(),
                            ));
                      },
                      child: Container(
                          width: screenWidthDp / 7,
                          height: screenWidthDp / 7,
                          padding: EdgeInsets.all(screenWidthDp / 25),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(0.0, 3.2))
                              ],
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp),
                              color: Color(0xff26A4FF)),
                          child: Container(
                            width: screenWidthDp / 50,
                            child: Image.asset(
                              "assets/Group 71.png",
                              width: screenWidthDp / 12,
                            ),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        width: screenWidthDp / 3.8,
                        height: screenWidthDp / 3.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenWidthDp),
                            border: Border.all(
                                color: Colors.white38,
                                width: screenWidthDp / 500)),
                        child: Container(
                          margin: EdgeInsets.all(screenWidthDp / 40),
                          width: screenWidthDp / 6,
                          height: screenWidthDp / 6,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp),
                              border: Border.all(color: Colors.white)),
                          child: Container(
                            margin: EdgeInsets.all(screenWidthDp / 40),
                            width: screenWidthDp / 6,
                            height: screenWidthDp / 6,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(screenWidthDp),
                                color: Colors.white,
                                border: Border.all(color: Colors.white)),
                            child: Icon(
                              Icons.create,
                              size: screenWidthDp / 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (papers > 0)
                          writerScrap(context,
                              latLng: LatLng(currentLocation.latitude,
                                  currentLocation.longitude));
                        else
                          scrap.toast('กระดาษคุณหมดแล้ว');
                      },
                    )
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(
                            screenWidthDp / 24,
                            screenWidthDp / 36,
                            screenWidthDp / 24,
                            screenWidthDp / 36),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                spreadRadius: 3.0,
                                offset: Offset(0.0, 3.2),
                              )
                            ],
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(screenWidthDp / 14.2)),
                        child: Text(
                          ' กำลังโหลดสแครป... ',
                          style: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: screenWidthDp / 18,
                              color: Colors.white),
                        )),
                    Container(
                        width: screenWidthDp / 7,
                        height: screenWidthDp / 7,
                        padding: EdgeInsets.all(screenWidthDp / 25),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0.0, 3.2))
                            ],
                            borderRadius: BorderRadius.circular(screenWidthDp),
                            color: Color(0xff26A4FF)),
                        child: Container(
                          width: screenWidthDp / 50,
                          child: Image.asset(
                            "assets/Group 71.png",
                            width: screenWidthDp / 12,
                          ),
                        )),
                    Container(
                      width: screenWidthDp / 3.8,
                      height: screenWidthDp / 3.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidthDp),
                          border: Border.all(
                              color: Colors.white38,
                              width: screenWidthDp / 500)),
                      child: Container(
                        margin: EdgeInsets.all(screenWidthDp / 40),
                        width: screenWidthDp / 6,
                        height: screenWidthDp / 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenWidthDp),
                            border: Border.all(color: Colors.white)),
                        child: Container(
                          margin: EdgeInsets.all(screenWidthDp / 40),
                          width: screenWidthDp / 6,
                          height: screenWidthDp / 6,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp),
                              color: Colors.white,
                              border: Border.all(color: Colors.white)),
                          child: Icon(
                            Icons.create,
                            size: screenWidthDp / 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ));
  }

  Widget gpsCheck(Size a, String text) {
    return Center(
      child: Container(
        width: a.width / 1.2,
        height: a.width / 3.2,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: a.width / 3.2,
                height: a.width / 3.2,
                child: FlareActor(
                  'assets/paper_loading.flr',
                  animation: 'Untitled',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  style: TextStyle(fontSize: a.width / 16, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  cameraAnime2(GoogleMapController controller, double howClose) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0),
        zoom: howClose,
        bearing: 0.0,
        tilt: 90)));
  }

  changeMapMode() {
    getJsonFile("assets/mapStyle.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    this.mapController.setMapStyle(mapStyle);
  }

  void onMapCreated(GoogleMapController controller) {
    this.mapController = controller;
    changeMapMode();
    if (this.mounted) {
      updateMap(currentLocation);
      subLimit = streamLimit.listen((value) {
        if (value > 0) addMoreScrap(value);
      });
      addMoreScrap(16);
    }
    streamLocation.onData((position) {
      if (this.mounted) {
        userMarker(position.latitude, position.longitude);
      }
    });
  }

  updateMap(Position location) {
    userMarker(location.latitude, location.longitude);
    _animateToUser(position: location);
  }

  void _updateMarkers(List<DocumentSnapshot> documentList, Position position) {
    userMarker(position.latitude, position.longitude);
    allScrap.addAll(documentList);
    documentList.forEach((DocumentSnapshot document) {
      var data = document.data;
      GeoPoint loca = data['position']['geopoint'];
      if (data['uid'] != widget.uid) {
        _addMarker(loca.latitude, loca.longitude, document, data['uid']);
      }
    });
  }

  _animateToUser({Position position}) async {
    var pos = await Geolocator().getCurrentPosition();
    this
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            position == null ? pos.latitude : position.latitude,
            position == null ? pos.longitude : position.longitude,
          ),
          zoom: 16.9,
          tilt: 90.0,
        )));
  }

  addMoreScrap(int limit) async {
    var pos = await Geolocator().getCurrentPosition();
    var ref = recentScrap == null
        ? Firestore.instance
            .collection('Scraps/hatyai/test')
            .orderBy('scrap.time', descending: true)
            .limit(limit)
        : Firestore.instance
            .collection('Scraps/hatyai/test')
            .orderBy('scrap.time', descending: true)
            .startAfterDocument(recentScrap)
            .limit(limit);
    var doc = await ref.getDocuments();
    if (doc.documents.length > 0) {
      recentScrap = doc.documents.last;
      _updateMarkers(doc.documents, pos);
    }
  }

  cameraAnime(GoogleMapController controller, double lat, double lng) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng), zoom: 18.5, bearing: 0.0, tilt: 90)));
  }

  void _addMarker(
      double lat, double lng, DocumentSnapshot doc, String writerUid) {
    final MarkerId markerId = MarkerId(doc.documentID);
    final counter = Provider.of<AdsCounterProvider>(context, listen: false);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: scrapIcon,
      onTap: () async {
        try {
          allScrap.remove(doc);
          markers.remove(markerId);
          setState(() {});
          dialog(doc);
          counter.count += 1;
          streamLimit.add(16 - allScrap.length);
        } catch (e) {
          print(e.toString());
          error(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต');
        }
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  userMarker(double lat, double lng) {
    MarkerId markerId = MarkerId('user');
    LatLng position = LatLng(lat, lng);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: _curcon,
      draggable: false,
    );
    if (this.mounted) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_curcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/yourlocation-icon-l.png')
          .then(_updateBitmap);
    }
  }

  Future<void> _createScrapImageFromAsset(BuildContext context) async {
    if (scrapIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              checkPlatform
                  ? 'assets/paper-mini01.png'
                  : 'assets/paper-mini01.png')
          .then(_updateBitScrap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _curcon = bitmap;
    });
  }

  void _updateBitScrap(BitmapDescriptor bitmap) {
    setState(() {
      scrapIcon = bitmap;
    });
  }

  increasHistTran(String uid, String date, String docID) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('history')
        .document(date)
        .updateData({docID: FieldValue.increment(1)});
  }
}
