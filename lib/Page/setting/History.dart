import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('ประวัติการทิ้งกระดาษ',
            style: TextStyle(fontSize: scr.width / 16),
            textAlign: TextAlign.center),
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
                return SizedBox();
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
          Text('คุณไม่มีประวัติการทิ้งกระดาษ',
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
                      style: TextStyle(fontSize: scr.width / 21),
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
                  : Container(
                      margin: EdgeInsets.only(left: 3.6, top: 3.6),
                      padding: EdgeInsets.all(2.8),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.6,
                              spreadRadius: 0.1,
                              offset: Offset(
                                0.0,
                                1.0,
                              ),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        time,
                        style: TextStyle(
                            fontSize: scr.width / 24,
                            color: Color(0xff26A4FF),
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      )),
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
                    height: a.height / 1,
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
                                                : ' ผุ้คนหยิบอ่าน $transac คน',
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
                                      width: a.width / 3.5,
                                      height: a.width / 6.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "ทิ้ง",
                                        style:
                                            TextStyle(fontSize: a.width / 15),
                                      ),
                                    ),
                                    onTap: () async {
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