import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class History extends StatefulWidget {
  final String uid;
  History({@required this.uid});
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map modify = {};
  List scrapsID = [];
  Set firstScrap = Set();
  QuerySnapshot cache;
  @override
  void initState() {
    initializeDateFormatting();
    Intl.defaultLocale = 'th';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          // AppBar(
          //   backgroundColor: Colors.black,
          //   title: Text('ประวัติการทิ้งกระดาษ',
          //       style: TextStyle(fontSize: scr.width / 16),
          //       textAlign: TextAlign.center),
          // ),
          PreferredSize(
        preferredSize: Size(double.infinity, scr.width / 4),
        child: Container(
          margin: MediaQuery.of(context).padding,
          width: scr.width,
          color: Colors.black,
          padding: EdgeInsets.only(
              top: scr.width / 18,
              right: scr.width / 25,
              left: scr.width / 25,
              bottom: scr.width / 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: scr.width / 7,
                  height: scr.width / 10,
                  margin: EdgeInsets.only(right: scr.width / 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(scr.width),
                      color: Colors.white),
                  child: Icon(Icons.arrow_back,
                      color: Colors.black, size: scr.width / 15),
                ),
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              Text('ประวัติการทิ้งสแครป',
                  style: TextStyle(
                    fontSize: scr.width / 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(6),
        alignment: Alignment.center,
        child: StreamBuilder(
            initialData: cache,
            stream: Firestore.instance
                .collection('Users')
                .document(widget.uid)
                .collection('history')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                cache = snapshot.data;
                List docs = snapshot.data.documents;
                docs.sort((a, b) => DateTime.parse(a['date'])
                    .compareTo(DateTime.parse(b['date'])));
                return docs?.length == null || docs.length == 0
                    ? guid(scr)
                    : gridRebuild(docs.reversed.toList(), scr);
                // Center(child: scrapGroup(docs.reversed.toList(), scr));
              } else {
                return Container(
                  height: scr.height,
                  width: scr.width,
                  child: Center(
                    child: Container(
                      width: scr.width / 3.6,
                      height: scr.width / 3.6,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.42),
                          borderRadius: BorderRadius.circular(12)),
                      child: FlareActor(
                        'assets/paper_loading.flr',
                        animation: 'Untitled',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget guid(Size scr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/paper.png',
            color: Colors.white60,
            height: scr.height / 10,
          ),
          Text('คุณไม่มีประวัติการทิ้งสแครป',
              style: TextStyle(color: Colors.white, fontSize: scr.width / 16),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget gridRebuild(List docs, Size scr) {
    modify = {};
    Map trans = {};
    scrapsID = [];
    for (DocumentSnapshot data in docs) {
      for (String id in data['scrapID']) {
        data['scrapID'].indexOf(id) == 0 ? firstScrap.add(id) : null;
        scrapsID.add(id);
        modify[id] = data['Scraps'][id];
        trans[id] = data[id];
      }
    }
    return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7383,
            crossAxisSpacing: 3.6,
            mainAxisSpacing: 3.6),
        children: scrapsID
            .map((id) =>
                scrap(modify[id], trans[id], scr, firstScrap.contains(id)))
            .toList());
  }

  Widget scrap(Map data, int transac, Size scr, bool first) {
    DateTime dateTime = data['time'].toDate();
    String time = DateFormat('Hm').format(dateTime);
    return Container(
      child: Center(
        child: InkWell(
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/paper-readed.png',
                width: scr.width / 3.2,
                height: scr.height / 4.2,
                fit: BoxFit.cover,
              ),
              Container(
                width: scr.width / 3.2,
                height: scr.height / 4.2,
                alignment: Alignment.center,
                child: SizedBox(
                    height: scr.height / 6,
                    child: Center(
                        child: Text(
                      data['text'],
                      style: TextStyle(fontSize: scr.width / 30),
                      textAlign: TextAlign.center,
                    ))),
              ),
              first
                  ? Positioned(
                      left: 2,
                      top: 6,
                      child: Container(
                          alignment: Alignment.center,
                          width: scr.width / 9.6,
                          height: scr.width / 7.8,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2.4,
                                spreadRadius: 1.8,
                                offset: Offset(
                                  1.0,
                                  1.0,
                                ),
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                getDate(data['time'], 'd'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scr.width / 18),
                              ),
                              Text(
                                getDate(data['time'], 'MMM'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scr.width / 26),
                              ),
                            ],
                          )),
                    )
                  : SizedBox()
              // Container(
              //     margin: EdgeInsets.only(left: 3.6, top: 3.6),
              //     padding: EdgeInsets.all(2.8),
              //     decoration: BoxDecoration(
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black12,
              //             blurRadius: 1.6,
              //             spreadRadius: 0.1,
              //             offset: Offset(
              //               0.0,
              //               1.0,
              //             ),
              //           )
              //         ],
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(6)),
              //     child: Text(
              //       time,
              //       style: TextStyle(
              //           fontSize: scr.width / 24,
              //           color: Color(0xff26A4FF),
              //           fontWeight: FontWeight.w500),
              //       textAlign: TextAlign.center,
              //     )),
            ],
          ),
          onTap: () {
            dialog(data['text'], transac,
                DateFormat('HH:mm dd/MM/yyyy').format(data['time'].toDate()));
          },
        ),
      ),
    );
  }

  String getDate(Timestamp timeStamp, String format) {
    String date;
    date = DateFormat(format).format(timeStamp.toDate());
    return date;
  }

  dialog(String text, int transac, String time) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    margin: EdgeInsets.only(
                      top: a.height / 8,
                    ),
                    padding: EdgeInsets.only(
                        left: a.width / 20, right: a.width / 20),
                    width: a.width,
                    height: a.height,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: a.width,
                                  child: Image.asset(
                                    'assets/paper-readed.png',
                                    width: a.width,
                                    height: a.height / 1.6,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      width: a.width / 1.2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('เขียนโดย : คุณ'),
                                              Text('เวลา : $time')
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  height: a.height / 1.6,
                                  // width: a.width / 1.2,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: a.width / 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // onTap: () {
                                  //   dialogPa(writerID, writer);
                                  // },
                                ),
                                Positioned(
                                    bottom: a.width / 21,
                                    right: a.width / 21,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.remove_red_eye,
                                            size: a.width / 18),
                                        Text(
                                            transac == 0
                                                ? ' ไม่มีคนหยิบอ่าน'
                                                : ' ผู้คนหยิบอ่าน $transac คน',
                                            style: TextStyle(
                                                fontSize: a.width / 18))
                                      ],
                                    ))
                              ],
                            ),
                            SizedBox(height: a.width / 15),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(width: a.width / 20),
                                  InkWell(
                                    child: Container(
                                      width: a.width / 6.5,
                                      height: a.width / 6.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: a.width / 15,
                                      ),
                                      // Text(
                                      //   "ปิด",
                                      //   style:
                                      //       TextStyle(fontSize: a.width / 15),
                                      // ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(width: a.width / 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
        fullscreenDialog: true));
  }
}
