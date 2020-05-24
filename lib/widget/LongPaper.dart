import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LongPaper extends StatefulWidget {
  final Map scrap;
  final String uid;
  LongPaper({@required this.scrap, @required this.uid});
  @override
  _LongPaperState createState() => _LongPaperState();
}

class _LongPaperState extends State<LongPaper> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
          margin: EdgeInsets.only(right: a.width / 15, top: a.width / 20),
          width: a.width / 1.3,
          height: a.width / 1.3,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/paper-readed.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Stack(
            children: <Widget>[
              Container(
                width: a.width,
                child: Image.asset(
                  'assets/paper-readed.png',
                  width: a.width / 1.3,
                  height: a.width,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.all(a.width / 40),
                width: a.width,
                height: a.width / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("เขียนโดย : ${widget.scrap['scap']['writer']}",
                            style: TextStyle(
                                fontSize: a.width / 22, color: Colors.grey)),
                        Text(
                          widget.scrap['scap']['time'].runtimeType == String
                              ? "เวลา : ${widget.scrap['scap']['time']}"
                              : "เวลา : ${DateFormat('HH:mm d/M/y').format(widget.scrap['scap']['time'].toDate())}",
                          style: TextStyle(
                              fontSize: a.width / 22, color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.black,
                      iconSize: a.width / 12,
                      onPressed: () async {
                        warning();
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(24),
                width: a.width / 1.3,
                height: a.width,
                alignment: Alignment.center,
                child: Text(
                  widget.scrap['scap']['text'],
                  style: TextStyle(height: 1.35, fontSize: a.width / 17),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )),
      onTap: () {
        dialogPaper();
      },
    );
  }

  dialogPaper() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Size a = MediaQuery.of(context).size;
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return Scaffold(
          body: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: a.width,
              height: a.height,
              alignment: Alignment.center,
              color: Colors.black,
              padding: EdgeInsets.only(left: a.width / 20, right: a.width / 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      Container(
                        padding: EdgeInsets.all(a.width / 40),
                        width: a.width,
                        height: a.width / 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "เขียนโดย : ${widget.scrap['scap']['writer']}",
                                    style: TextStyle(
                                        fontSize: a.width / 22,
                                        color: Colors.grey)),
                                Text(
                                  widget.scrap['scap']['time'].runtimeType ==
                                          String
                                      ? "เวลา : ${widget.scrap['scap']['time']}"
                                      : "เวลา : ${DateFormat('HH:mm d/M/y').format(widget.scrap['scap']['time'].toDate())}",
                                  style: TextStyle(
                                      fontSize: a.width / 22,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(24),
                        width: a.width,
                        height: a.height / 1.6,
                        alignment: Alignment.center,
                        child: Text(
                          widget.scrap['scap']['text'],
                          style:
                              TextStyle(height: 1.35, fontSize: a.width / 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: a.width / 15),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: a.width / 20),
                        InkWell(
                          child: Container(
                            width: a.width / 6.5,
                            height: a.width / 6.5,
                            decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(a.width)),
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
            ),
          ),
        );
      });
    }));
  }

  warning() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องการลบสแครปแผ่นนี้ใช่หรือไม่'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ใช่'),
                onPressed: () async {
                  Navigator.pop(context);
                  await remove();
                },
              )
            ],
          );
        });
  }

  remove() async {
    await Firestore.instance
        .collection('Users')
        .document(widget.uid)
        .collection('scraps')
        .document('collection')
        .setData({
      'scraps': {
        widget.scrap['id']: FieldValue.arrayRemove([this.widget.scrap['scap']])
      }
    }, merge: true);
  }
}
