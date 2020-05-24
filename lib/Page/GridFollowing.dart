import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/ScreenUtil.dart';

import 'dart:math' as math;
class GridFollowing extends StatefulWidget {
  @override
  _GridFollowingState createState() => _GridFollowingState();
}

class _GridFollowingState extends State<GridFollowing> {
  bool loading = true;
  List<DocumentSnapshot> scraps = [];
  List friends = [];
  var controller = RefreshController();

  @override
  void initState() {
    initScraps();
    super.initState();
  }

  initScraps() async {
    friends = await jsonConv.readFriendList();
    var docs = await Firestore.instance
        .collectionGroup('scrapCollection')
        .where('picker', whereIn: friends)
        .orderBy('timeStamp', descending: true)
        .limit(2)
        .getDocuments();
    scraps.addAll(docs.documents);
    setState(() => loading = false);
  }

  loadMoreScrap() async {
    var docs = await Firestore.instance
        .collectionGroup('scrapCollection')
        .where('picker', whereIn: friends)
        .orderBy('timeStamp', descending: true)
        .startAfterDocument(scraps.last)
        .limit(2)
        .getDocuments();
    scraps.addAll(docs.documents);
    setState(() => docs.documents.length < 0
        ? controller.loadComplete()
        : controller.loadNoData());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : scraps.length > 0
              ? SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: false,
                  controller: controller,
                  onLoading: () {
                    loadMoreScrap();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: a.width / 42, right: a.width / 42),
                    width: a.width,
                    child: Wrap(
                        spacing: a.width / 42,
                        runSpacing: a.width / 42,
                        alignment: WrapAlignment.center,
                        children: scraps
                            .map((scrap) => block(scrap['timeStamp'].toDate()))
                            .toList()),
                  ),
                )
              : Center(
                  child: Text(
                    'ไม่มีการเคลื่อนไหวในเพื่อนของคุณเลย',
                    style: TextStyle(
                      fontSize: s48,
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                ),
    );
  }

  Widget block(data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            width: a.width / 2.2,
            height: (a.width / 2.1) * 1.21,
            color: Colors.white,
            child: Center(
              child: Text(
                DateFormat('d/M/y').format(data),
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(a.width / 45),
              alignment: Alignment.center,
              width: a.width / 6,
              height: a.width / 13,
              decoration: BoxDecoration(
                  color: Color(0xff2D2D2F),
                  borderRadius: BorderRadius.circular(a.width / 80)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "1.2K",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: a.width / 20),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.sms,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // controller.refreshCompleted();
      },
    );
  }
}
