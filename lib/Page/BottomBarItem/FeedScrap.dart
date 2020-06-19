import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scrap/bloc/TestBloc.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/services/LoadStatus.dart';
import 'package:scrap/stream/FeedStream.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';

class FeedScrap extends StatefulWidget {
  @override
  _FeedScrapState createState() => _FeedScrapState();
}

class _FeedScrapState extends State<FeedScrap>
    with AutomaticKeepAliveClientMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initHistory = false, loadingFeed = false;
  int current = 0;
  var pageController = PageController();
  StreamSubscription loadStream;
  Map<String, List> history = {};

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  bool isExpired(DateTime litteredTime) {
    DateTime startTime = litteredTime;
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  @override
  void initState() {
    initUserHistory();
    initScrap();
    loadStream = loadStatus.feedStatus
        .listen((event) => setState(() => loadingFeed = event));
    super.initState();
  }

  void listener() {
    if (pageController.position.pixels >
        pageController.position.maxScrollExtent)
      toast.toast('คุณตามทันสแครปทั้งหมดแล้ว');
  }

  Future<void> initUserHistory() async {
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    history['burn'] = await cacheHistory.readOnlyId(field: 'burn') ?? [];
    setState(() => initHistory = true);
  }

  void initScrap() {
    if (feed.scraps == null || feed.scraps.length < 1) feed.initFeed();
  }

  @override
  void dispose() {
    pageController.dispose();
    loadStream.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loadingFeed || !initHistory
                ? Center(child: LoadNoBlur())
                : Expanded(
                    child: StreamBuilder(
                        initialData: feed.scraps,
                        stream: feed.feedStream,
                        builder: (context,
                            AsyncSnapshot<List<ScrapModel>> snapshot) {
                          if (snapshot.hasData) {
                            return Listener(
                              onPointerUp: (event) => listener(),
                              child: PageView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    if (current + 1 == index) {
                                      feed.scraps.length < 24
                                          ? feed.loadMore()
                                          : feed.clearOldScrap();
                                    }
                                    current = index;
                                  },
                                  scrollDirection: Axis.vertical,
                                  children: snapshot.data
                                      .map((data) => scrapWidget(data))
                                      .toList()),
                            );
                          } else {
                            return Center(child: LoadNoBlur());
                          }
                        }),
                  ),
            // RaisedButton(
            //     child: Text('increment && loadMore'),
            //     onPressed: () {
            //       feed.loadMore();
            //     }),
            // RaisedButton(
            //     child: Text('decrement'),
            //     onPressed: () {
            //       counterBloc.add(CounterEvents.decrement);
            //     }),
          ],
        )));
  }

  Widget scrapWidget(ScrapModel scrapModel) {
    var transac = scrapModel.transaction;
    return StatefulBuilder(builder: (context, StateSetter setDialog) {
      var like = transac.like;
      var pick = transac.picked;
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: (screenWidthDp - screenWidthDp / 1.04) / 2),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // counter.count == adsRate
                //     ? Center(
                //         child: Text(
                //         'โฆษณา',
                //         style: TextStyle(
                //             fontSize: s42,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold),
                //       ))
                //     :
                SizedBox(height: screenHeightDp / 42),
                // counter.count == adsRate
                //     ? Container(
                //         width: a.width / 1.04,
                //         height: a.width / 1.04 * 1.115,
                //         decoration: BoxDecoration(
                //             image: DecorationImage(
                //                 image: AssetImage(
                //                     'assets/paperscrap.jpg'),
                //                 fit: BoxFit.cover)),
                //         child: AdmobBanner(
                //             adUnitId:
                //                 AdmobService().getBannerAdId(),
                //             adSize: AdmobBannerSize
                //                 .MEDIUM_RECTANGLE),
                //       )
                //     :
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: screenWidthDp / 1.04,
                      height: screenWidthDp / 1.04 * 1.115,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 25, right: 25),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/paperscrap.jpg'),
                        fit: BoxFit.cover,
                      )),
                      child: Text(scrapModel.text,
                          style: TextStyle(height: 1.35, fontSize: s60),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: screenWidthDp / 36),
                    Container(
                      width: screenWidthDp,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                scrapModel.writer == 'ไม่ระบุตัวตน'
                                    ? 'ใครบางคน'
                                    : '@${scrapModel.writer}',
                                style: TextStyle(
                                    fontSize: s48,
                                    height: 1.1,
                                    color: scrapModel.writer == 'ไม่ระบุตัวตน'
                                        ? Colors.white
                                        : Color(0xff26A4FF)),
                              ),
                              CountDownText(startTime: scrapModel.litteredTime)
                            ],
                          ),
                          GestureDetector(
                              child: Icon(Icons.more_horiz,
                                  color: Colors.white, size: s70),
                              onTap: () => showMore(context, scrap: scrapModel))
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
                        //                 iconColor:
                        //                     Color(0xff000000),
                        //                 icon: Icons.forward),
                        //             onTap: () {
                        //               randomAdsRate();
                        //               counter.count = 0;
                        //               setDialog(() {});
                        //             }))
                        //     :
                        StatefulBuilder(
                            builder: (context, StateSetter setTrans) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: screenWidthDp / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  child: iconWithLabel(like.abs().toString(),
                                      icon:
                                          inHistory('like', scrapModel.scrapId)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                      background:
                                          inHistory('like', scrapModel.scrapId)
                                              ? Color(0xffFF4343)
                                              : Colors.white,
                                      iconColor:
                                          inHistory('like', scrapModel.scrapId)
                                              ? Colors.white
                                              : Color(0xffFF4343)),
                                  onTap: () {
                                    if (isExpired(scrapModel.litteredTime)) {
                                      toast.toast('สเเครปนี้ย่อยสลายแล้ว');
                                    } else {
                                      scrap.updateScrapTrans('like', context,
                                          scrap: scrapModel);
                                      if (inHistory(
                                          'like', scrapModel.scrapId)) {
                                        ++like;
                                        history['like']
                                            .remove(scrapModel.scrapId);
                                      } else {
                                        --like;
                                        history['like'].add(scrapModel.scrapId);
                                      }
                                      setTrans(() {});
                                    }
                                  },
                                ),
                                GestureDetector(
                                  child: iconWithLabel(pick.abs().toString(),
                                      background: inHistory(
                                              'picked', scrapModel.scrapId)
                                          ? Color(0xff0099FF)
                                          : Colors.white,
                                      iconColor: inHistory(
                                              'picked', scrapModel.scrapId)
                                          ? Colors.white
                                          : Color(0xff0099FF),
                                      icon: Icons.move_to_inbox),
                                  onTap: () {
                                    if (isExpired(scrapModel.litteredTime)) {
                                      scrap.toast('สเเครปนี้ย่อยสลายแล้ว');
                                    } else {
                                      scrap.updateScrapTrans('picked', context,
                                          scrap: scrapModel,
                                          comments: transac.comment);
                                      if (inHistory(
                                          'picked', scrapModel.scrapId)) {
                                        ++pick;
                                        history['picked']
                                            .remove(scrapModel.scrapId);
                                      } else {
                                        --pick;
                                        history['picked']
                                            .add(scrapModel.scrapId);
                                      }
                                      setTrans(() {});
                                    }
                                  },
                                ),
                                GestureDetector(
                                  child: iconWithLabel(
                                      transac.comment.abs().toString(),
                                      iconColor:
                                          Color(0xff000000).withOpacity(0.83),
                                      icon: Icons.sms),
                                  onTap: () {
                                    Scaffold.of(context).showBottomSheet(
                                      (BuildContext context) => CommentSheet(
                                          scrapSnapshot: scrapModel),
                                      backgroundColor: Colors.transparent,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          scrapModel.position != null
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right: screenWidthDp / 42),
                                  child: GestureDetector(
                                    child: iconWithLabel('ตำแหน่ง',
                                        iconColor: Color(0xff000000),
                                        icon: Icons.location_on),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          MapSheet(
                                              position: scrapModel.position),
                                      // backgroundColor:
                                      //     Colors.transparent,
                                    )
                                    // counter.count += 1;
                                    // allScrap.remove(data);
                                    // markers.remove(MarkerId(
                                    //     data.documentID));
                                    // if (allScrap.isNotEmpty &&
                                    //     allScrap.length > 0) {
                                    //   setDialog(() =>
                                    //       data = allScrap.first);
                                    //   streamLimit.add(
                                    //       16 - allScrap.length);
                                    // } else {
                                    //   toast.toast(
                                    //       'คุณตามทันสแครปทั้งหมดแล้ว');
                                    // }
                                    ,
                                  ),
                                )
                              : SizedBox()
                        ],
                      );
                    })),
              ]));
    });
  }

  Widget burntScrap({@required Function onNext}) {
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
                  GestureDetector(
                    child: iconWithLabel('ต่อไป',
                        iconColor: Color(0xff000000), icon: Icons.forward),
                    onTap: onNext,
                  ),
                ],
              )),
          SizedBox(height: screenWidthDp / 36),
        ]);
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

  void showMore(context, {@required ScrapModel scrap}) {
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
                  /* margin: EdgeInsets.only(
                bottom: appBarHeight - 20,
              ),*/
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
                                  child: Icon(Icons.whatshot,
                                      color: Color(0xffFF8F3A),
                                      size: appBarHeight / 3)),
                              onTap: () {
                                if (inHistory('burn', scrap.scrapId)) {
                                  toast.toast('คุณเคยเผาสแครปก้อนนี้แล้ว');
                                } else {
                                  final report = Provider.of<Report>(context,
                                      listen: false);
                                  report.scrapId = scrap.scrapId;
                                  report.scrapRef = scrap.path.parent().path;
                                  report.targetId = scrap.writerUid;
                                  report.region = scrap.scrapRegion;
                                  showdialogBurn(context,
                                      burntScraps: history['burn']);
                                }
                              },
                            ),
                            Text(
                              'เผา',
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
                                report.targetId = scrap.writerUid;
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
                /* Positioned(
                bottom: 0,
                child: Container(
                  child: AdmobBanner(
                      adUnitId: AdmobService().getBannerAdId(),
                      adSize: AdmobBannerSize.FULL_BANNER),
                )),*/
              ],
            ),
          );
        });
  }

  /*
    showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                MapSheet(
                                              position: LatLng(
                                                  data['position']['geopoint']
                                                      .latitude,
                                                  data['position']['geopoint']
                                                      .longitude),
                                            ),
                                            // backgroundColor:
                                            //     Colors.transparent,
                                          );
   */
}
