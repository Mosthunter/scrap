import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/CreatePaper.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ProfileCard.dart';
import 'package:scrap/widget/Toast.dart';

class Search extends StatefulWidget {
  final DocumentSnapshot doc;
  final Map data;
  Search({@required this.doc, this.data});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String id;
  var _key = GlobalKey<FormState>();
  DocumentSnapshot cache;
  Scraps scraps = Scraps();
  JsonConverter jsonConverter = JsonConverter();
  List friends = [];
  bool loading = false;

  @override
  void initState() {
    initeFriend();
    super.initState();
  }

  initeFriend() async {
    friends = await jsonConverter.readContents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                width: a.width,
                child: ListView(
                  children: <Widget>[
                    Container(
                      // color: Colors.white,
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
                                  child: Container(
                                    width: a.width / 7,
                                    height: a.width / 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                        color: Colors.white),
                                    child: Icon(Icons.arrow_back,
                                        color: Colors.black,
                                        size: a.width / 15),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            ), //back btn
                            SizedBox(
                              height: a.height / 12.5,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: a.width / 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "ค้นหาไอดี",
                                    style: TextStyle(
                                        fontSize: a.width / 6.5,
                                        color: Colors.white),
                                  ),
                                  Text("ค้นหาไอดีแล้วปาสแครปใส่พวกเขากัน",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 16)),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: a.width / 10,
                                right: a.width / 30,
                                left: a.width / 30,
                              ),
                              height: a.width / 7.5,
                              width: a.width,
                              decoration: BoxDecoration(
                                  color: Color(0xff282828),
                                  borderRadius: BorderRadius.circular(a.width)),
                              child: Form(
                                key: _key,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: a.width / 25, right: a.width / 55),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(width: 1),
                                      Container(
                                          width: a.width / 1.6,
                                          height: a.width / 6.4,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                hintText: '@someone',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            style: TextStyle(
                                              height: 1.21,
                                              color: Color(0xff0094FF),
                                              fontSize: a.width / 16,
                                            ),
                                            validator: (val) {
                                              return val.trim() == ""
                                                  ? Taoast()
                                                      .toast("อย่าลืมใส่ไอดี")
                                                  : val[0] == '@'
                                                      ? null
                                                      : Taoast().toast(
                                                          "ค้นหาคนที่คุณจะปาใส่โดยใส่@ตามด้วยชื่อid");
                                            },
                                            onSaved: (value) {
                                              id = value.trim();
                                              setState(() {});
                                            },
                                            textInputAction:
                                                TextInputAction.done,
                                          )),
                                      Container(
                                        alignment: Alignment.center,
                                        width: a.width / 9.6,
                                        height: a.width / 9.6,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          color: Color(0xff26A4FF),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.search,
                                              color: Colors.white,
                                              size: a.width / 18),
                                          onPressed: () {
                                            if (_key.currentState.validate()) {
                                              _key.currentState.save();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            id == null ||
                                    id == '' ||
                                    id.length < 2 ||
                                    id.substring(1) == widget.doc['id']
                                ? guide(
                                    a,
                                    'ค้นหาคนที่คุณต้องการปาใส่',
                                    a.height / 2.5,
                                  )
                                : StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('SearchUsers')
                                        .document(id[1])
                                        .collection('users')
                                        .where('id', isEqualTo: id.substring(1))
                                        .limit(1)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.active) {
                                        List docs = snapshot.data.documents;
                                        return docs?.length == null ||
                                                docs?.length == 0
                                            ? guide(
                                                a,
                                                'ขออภัยค่ะเราไม่พบผู้ใช้ดังกล่าว',
                                                a.height / 2.5,
                                              )
                                            : Column(
                                                children: docs
                                                    .map((data) => cardStream(
                                                        a, data['uid']))
                                                    .toList(),
                                              );
                                      } else {
                                        return Container(
                                          height: a.height / 2.1,
                                          width: a.width,
                                          child: Center(
                                            child: Container(
                                              width: a.width / 3.6,
                                              height: a.width / 3.6,
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.42),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                  ],
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          ),
        )

        // Scaffold(
        //   backgroundColor: Colors.black,
        //   body: Stack(
        //     children: <Widget>[
        //       ListView(children: <Widget>[
        //         Container(
        //           color: Colors.black,
        //           width: a.width,
        //           child: Padding(
        //             padding: EdgeInsets.only(
        //                 top: a.width / 20,
        //                 right: a.width / 25,
        //                 left: a.width / 25,
        //                 bottom: a.width / 8.0),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: <Widget>[
        //                 Column(
        //                   children: <Widget>[
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: <Widget>[
        //                         InkWell(
        //                           child: Container(
        //                             width: a.width / 7,
        //                             height: a.width / 10,
        //                             decoration: BoxDecoration(
        //                                 borderRadius:
        //                                     BorderRadius.circular(a.width),
        //                                 color: Colors.white),
        //                             child: Icon(Icons.arrow_back,
        //                                 color: Colors.black, size: a.width / 15),
        //                           ),
        //                           onTap: () {
        //                             Navigator.pop(context, true);
        //                           },
        //                         ),
        //                       ],
        //                     ), //back btn
        //                     SizedBox(height: a.height / 12.5),
        //                     Padding(
        //                       padding: const EdgeInsets.only(left: 0),
        //                       child: Column(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: <Widget>[
        //                           Text(
        //                             'ค้นหาผู้ใช้',
        //                             style: TextStyle(
        //                                 fontSize: a.width / 6.5,
        //                                 color: Colors.white,
        //                                 fontWeight: FontWeight.w300),
        //                           ),
        //                           Text(
        //                             'ค้นหาคนที่คุณรู้จักแ���้วปากระดาษใส่พวกเขากัน',
        //                             style: TextStyle(
        //                                 fontSize: a.width / 16,
        //                                 color: Colors.white,
        //                                 fontWeight: FontWeight.w300),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       height: a.width / 13,
        //                     ),
        //                     Form(
        //                       key: _key,
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                         children: <Widget>[
        //                           Padding(
        //                             padding: const EdgeInsets.all(5.0),
        //                             child: Container(
        //                               margin: EdgeInsets.only(bottom: 30),
        //                               width: a.width / 1.4,
        //                               height: a.width / 6.5,
        //                               decoration: BoxDecoration(
        //                                 color: Color(0xff282828),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(300)),
        //                                 border: Border.all(
        //                                     width: 2, color: Colors.grey[800]),
        //                               ),
        //                               child: TextFormField(
        //                                 textAlign: TextAlign.center,
        //                                 style: TextStyle(
        //                                   color: Colors.white,
        //                                   fontSize: a.width / 14,
        //                                   fontWeight: FontWeight.w300,
        //                                 ),
        //                                 keyboardType: TextInputType.emailAddress,
        //                                 decoration: InputDecoration(
        //                                   border: InputBorder.none,
        //                                   hintText: '@somename',
        //                                   hintStyle:
        //                                       TextStyle(color: Colors.grey[700]),
        //                                 ),
        //                                 validator: (val) {
        //                                   return val.trim() == ""
        //                                       ? Taoast().toast("โปรดใส่ไอดี")
        //                                       : val[0] == '@'
        //                                           ? null
        //                                           : Taoast().toast(
        //                                               "ค้นหาคนที่คุณจะปาใส่โดยใส่@ตามด้วยชื่อid");
        //                                 },
        //                                 onSaved: (value) {
        //                                   id = value.trim();
        //                                   setState(() {});
        //                                 },
        //                                 textInputAction: TextInputAction.done,
        //                               ),
        //                             ),
        //                           ),
        //                           InkWell(
        //                             child: Container(
        //                                 margin: EdgeInsets.only(bottom: 30),
        //                                 alignment: Alignment.center,
        //                                 width: a.width / 8,
        //                                 height: a.width / 8,
        //                                 decoration: BoxDecoration(
        //                                   borderRadius:
        //                                       BorderRadius.circular(a.width),
        //                                   border: Border.all(
        //                                       width: 2, color: Colors.white),
        //                                   color: Color(0xff26A4FF),
        //                                 ),
        //                                 child: Text(
        //                                   '@',
        //                                   textAlign: TextAlign.center,
        //                                   style: TextStyle(
        //                                       fontSize: a.width / 11,
        //                                       color: Colors.white),
        //                                 )),
        //                             onTap: () {
        //                               if (_key.currentState.validate()) {
        //                                 _key.currentState.save();
        //                               }
        //                             },
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 id == null ||
        //                         id == '' ||
        //                         id.length < 2 ||
        //                         id.substring(1) == widget.doc['id']
        //                     ? guide(
        //                         a,
        //                         'ค้นหาคนที่คุณต้องการปาใส่',
        //                         a.height / 2.1,
        //                       )
        //                     : StreamBuilder(
        //                         stream: Firestore.instance
        //                             .collection('SearchUsers')
        //                             .document(id[1])
        //                             .collection('users')
        //                             .where('id', isEqualTo: id.substring(1))
        //                             .limit(1)
        //                             .snapshots(),
        //                         builder: (context, snapshot) {
        //                           if (snapshot.hasData &&
        //                               snapshot.connectionState ==
        //                                   ConnectionState.active) {
        //                             List docs = snapshot.data.documents;
        //                             return docs?.length == null ||
        //                                     docs?.length == 0
        //                                 ? guide(
        //                                     a,
        //                                     'ขออภัยค่ะเราไม่พบผู้ใช้ดังกล่าว',
        //                                     a.height / 1.5,
        //                                   )
        //                                 : Column(
        //                                     children: docs
        //                                         .map((data) =>
        //                                             cardStream(a, data['uid']))
        //                                         .toList(),
        //                                   );
        //                           } else {
        //                             return Container(
        //                               height: a.height / 2.1,
        //                               width: a.width,
        //                               child: Center(
        //                                 child: Container(
        //                                   width: a.width / 3.6,
        //                                   height: a.width / 3.6,
        //                                   decoration: BoxDecoration(
        //                                       color:
        //                                           Colors.white.withOpacity(0.42),
        //                                       borderRadius:
        //                                           BorderRadius.circular(12)),
        //                                   child: FlareActor(
        //                                     'assets/paper_loading.flr',
        //                                     animation: 'Untitled',
        //                                     fit: BoxFit.cover,
        //                                   ),
        //                                 ),
        //                               ),
        //                             );
        //                           }
        //                         })
        //               ],
        //             ),
        //           ),
        //         ),
        //       ]),
        //       loading ? Loading() : SizedBox()
        //     ],
        //   ),
        // ),
        );
  }

  Widget cardStream(Size a, String searchID) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(searchID)
            .collection('info')
            .document(searchID)
            .snapshots(),
        builder: (context, info) {
          if (info.hasData && info.connectionState == ConnectionState.active) {
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('Users')
                    .document(searchID)
                    .snapshots(),
                builder: (context, acc) {
                  if (acc.hasData &&
                      acc.connectionState == ConnectionState.active) {
                    return userSection(a, acc.data, info.data);
                  } else {
                    return SizedBox();
                  }
                });
          } else {
            return SizedBox();
          }
        });
  }

  Widget userSection(Size a, DocumentSnapshot acc, DocumentSnapshot info) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            right: a.width / 30,
            left: a.width / 30,
          ),
          child: ProfileCard(
              acc: acc,
              info: info,
              addSahai: () async {
                await addFriend(
                    acc['uid'], acc['id'], info['img'], info['createdDay']);
                Taoast().toast("เพิ่ม ${acc['id']} เป็นสหายแล้ว");
              },
              isFriend:
                  friends.where((data) => data['id'] == acc['id']).length == 1),
        ),
        Container(
          margin: EdgeInsets.only(
            top: a.width / 17,
            bottom: a.width / 17,
            right: a.width / 30,
            left: a.width / 30,
          ),
          width: a.width,
          child: Row(
            // ใส���� Row ��พื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: a.width / 20),
                height: a.width / 5,
                decoration: BoxDecoration(
                    color: Color(0xff282828),
                    borderRadius: BorderRadius.circular(a.width / 20)),
                child: Row(
                  children: <Widget>[
                    Container(
                      //color: Colors.black,
                      width: a.width / 5,
                      child: Column(
                        //เพื่อใช้สำหรับให้ จำนวน และ เขียน
                        children: <Widget>[
                          Text(
                            "เขียน",
                            style: TextStyle(
                                color: Colors.white, fontSize: a.width / 34),
                          ),
                          Text(
                            '${info['written'] ?? 0}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: a.width / 5,
                      // color: Colors.blue,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "ผู้คนหยิบอ่าน",
                            style: TextStyle(
                                color: Colors.white, fontSize: a.width / 34),
                          ),
                          Text(
                            //เพื่อใช้สำหรับ��ห้ จำนวน และ ผ�����้หยิบอ่าน
                            '${info['read'] ?? 0}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: a.width / 5,
                      //  color: Colors.blue,
                      child: Column(
                        //เพื่อใช้สำหรับให้ จำนวน ��ละ โ��นปาใส��
                        children: <Widget>[
                          Text(
                            "โดนปาใส่",
                            style: TextStyle(
                                color: Colors.white, fontSize: a.width / 34),
                          ),
                          Text(
                            '${info['threw'] ?? 0}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: a.width / 5,
                height: a.width / 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(a.width),
                    border: Border.all(
                        color: Colors.white24, width: a.width / 500)),
                child: Container(
                  margin: EdgeInsets.all(a.width / 45),
                  width: a.width / 5,
                  height: a.width / 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(a.width),
                      border: Border.all(color: Colors.white70)),
                  child: Container(
                    margin: EdgeInsets.all(a.width / 52),
                    width: a.width / 5,
                    height: a.width / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(a.width),
                        color: Colors.white,
                        border: Border.all(color: Colors.white)),
                    child: IconButton(
                      icon: Icon(
                          widget.data == null ? Icons.create : Icons.send,
                          size: a.width / 18,
                          color: Colors.black),
                      onPressed: () {
                        widget.data == null
                            ? dialogWrite(widget.doc['id'], widget.doc['uid'],
                                acc['uid'], acc['id'])
                            : warnDialog(acc['id'], acc['uid']);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  dialogWrite(String id, String uid, String thrownUID, String tID) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WriteScrap(
              id: id,
              thrownUID: thrownUID,
              uid: uid,
              tID: tID,
            ),
        fullscreenDialog: true));
  }

  Widget guide(Size a, String text, double heigth) {
    return Container(
      height: heigth,
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

  warnDialog(String user, String thrownUID) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องการปาใส่' + user + 'ใช่หรือไม่'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(
                child: Text('ตกลง'),
                onPressed: () async {
                  if (await scraps.blocked(widget.doc['uid'], thrownUID)) {
                    toast('คุณไม่สามารถปาไปหา"$user"ได้');
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await scraps.throwTo(context,
                        uid: widget.doc['uid'],
                        writer: widget.doc['id'],
                        thrownUID: thrownUID,
                        text: widget.data['text']);
                    toast('ปาใส่"$user"แล้ว');
                  }
                },
              )
            ],
          );
        });
  }

  addFriend(String uid, String newFriend, String img, dynamic join) async {
    setState(() => loading = true);
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document('friends')
        .setData({
      'friendList': FieldValue.arrayUnion([uid])
    }, merge: true);
    await jsonConverter.addContent(
        uid: uid,
        id: newFriend,
        imgUrl: img,
        joinD: join.runtimeType == String
            ? join
            : DateFormat('d/M/y').format(join.toDate()));
    loading = false;
    setState(() => friends.add({'id': newFriend, 'imgUrl': img, 'join': join}));
  }

  toast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1,
        backgroundColor: Colors.white60,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
