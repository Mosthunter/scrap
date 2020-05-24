import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/warning.dart';

class NotificationHistory extends StatefulWidget {
  final DocumentSnapshot doc;
  NotificationHistory({@required this.doc});
  @override
  _NotificationHistoryState createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  bool loading = false;

  deleteHistory(String id) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('notification')
        .document(id)
        .delete();
  }

  clearHistory(List docs) async {
    setState(() {
      loading = true;
    });
    for (var doc in docs) {
      await deleteHistory(doc.documentID);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ListView(children: <Widget>[
            Container(
              color: Colors.black,
              width: a.width,
              child: Padding(
                padding: EdgeInsets.only(
                    top: a.width / 20,
                    right: a.width / 25,
                    left: a.width / 25,
                    bottom: a.width / 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          //back btn
                          child: Container(
                            width: a.width / 7,
                            height: a.width / 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(a.width),
                                color: Colors.white),
                            child: Icon(Icons.arrow_back,
                                color: Colors.black, size: a.width / 15),
                          ),
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            await Firestore.instance
                                .collection('Users')
                                .document(widget.doc['uid'])
                                .collection('notification')
                                .getDocuments()
                                .then((docs) {
                              if (docs?.documents?.length == null ||
                                  docs?.documents?.length == 0) {
                              } else {
                                Dg().warnDialog(context,
                                    'คุณต้องการลบการแจ้งเตือนทั้งหมดนี้ใช่หรือไม่',
                                    () async {
                                  Navigator.pop(context);
                                  await clearHistory(docs.documents);
                                });
                              }
                            });
                          },
                          icon: Icon(
                            Icons.clear_all,
                            color: Color(0xff26A4FF),
                            size: a.width / 20,
                          ),
                          label: Text(
                            "ล้าง",
                            style: TextStyle(
                                color: Color(0xff26A4FF),
                                fontSize: a.width / 16),
                          ),
                        ),
                      ],
                    ), //back btn
                    SizedBox(height: a.height / 12.5),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'การแจ้งเตือน',
                            style: TextStyle(
                                fontSize: a.width / 6.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('Users')
                            .document(widget.doc['uid'])
                            .collection('notification')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            List documents = snapshot?.data?.documents;
                            return documents?.length == null ||
                                    documents?.length == 0
                                ? guide(a, 'ขณะนี้คุณยังไม่มีการแจ้งเตือน')
                                : Column(
                                    children: documents.reversed
                                        .toList()
                                        .map((doc) => notiBox(a, doc))
                                        .toList(),
                                  );
                          } else {
                            return Container(
                              height: a.height / 1.8,
                              width: a.width,
                              child: Center(
                                child: Container(
                                  width: a.width / 3.6,
                                  height: a.width / 3.6,
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
                  ],
                ),
              ),
            ),
          ]),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  Widget guide(Size a, String text) {
    return Container(
      height: a.height / 1.8,
      width: a.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/paper.png',
            color: Colors.white60,
            height: a.height / 10,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: a.width / 16,
                color: Colors.white60,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget notiBox(Size a, DocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: a.height / 7,
            width: a.width,
            decoration: BoxDecoration(
                color: Color(0xff282828),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(0.0),
                )),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: a.width / 1.2,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                child: Text(
                                  doc.data['writer'] == 'ไม่ระบุตัวตน'
                                      ? 'ใครบางคน'
                                      : '@' + doc.data['writer'],
                                  style: TextStyle(
                                      fontSize: a.width / 15,
                                      color:
                                          doc.data['writer'] == 'ไม่ระบุตัวตน'
                                              ? Colors.white
                                              : Color(0xff26A4FF)),
                                ),
                              ),
                              Text(
                                'ปาสแครปใส่คุณ',
                                style: TextStyle(
                                    fontSize: a.width / 15,
                                    color: Colors.grey[300]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${doc.data['time']} ${doc.data['date']}',
                          style: TextStyle(
                              fontSize: a.width / 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Positioned(
            right: 10.0,
            top: 10.0,
            child: IconButton(
              icon: Icon(Icons.clear),
              color: Color(0xffA3A3A3),
              iconSize: 30.0,
              onPressed: () {
                Dg().warnDialog(
                  context,
                  'คุณต้องการลบการแจ้งเตือนนี้ใช่หรือไม่',
                  () async {
                    Navigator.pop(context);
                    await deleteHistory(doc.documentID);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
