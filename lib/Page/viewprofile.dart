import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrap/function/cacheManage/friendManager.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class Viewprofile extends StatefulWidget {
  final DocumentSnapshot self;
  final String id;
  final Map data;
  Viewprofile({@required this.self, @required this.id, this.data});
  @override
  _ViewprofileState createState() => _ViewprofileState();
}

class _ViewprofileState extends State<Viewprofile> {
  bool loading = true;
  String text, img; // <== Don't forget to init value
  String friendUID;
  List friends = [];
  int index;
  bool oldImg = false;
  Scraps scraps = Scraps();
  JsonConverter jsonConverter = JsonConverter();
  FriendManager friendManager = FriendManager();

  @override
  void initState() {
    initFriend();
    super.initState();
  }

  Future<bool> notHaveAccount(String user) async {
    final QuerySnapshot users = await Firestore.instance
        .collection('Users')
        .where('id', isEqualTo: user)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = users.documents;
    if (doc.length == 1) {
      friendUID = doc[0].documentID;
    }
    return doc.length < 1;
  }

  checkData() async {
    List list = await jsonConverter.readContents();
    Map data = list.firstWhere((dat) => dat['id'] == widget.id);
    img = data['img'];
    index = list.indexOf(data);
    if (await notHaveAccount(widget.id)) {
      await updateData(list);
    }
    friends = await jsonConverter.readContents();
  }

  updateData(List list) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.self.data['uid'])
        .collection('info')
        .document('friends')
        .get()
        .then((doc) async {
      friendUID = doc.data['friendList'][index];
      await friendManager.updateData(friendUID, index);
    });
  }

  initFriend() async {
    await checkData();
    loading = false;
    setState(() {});
  }

  editFriend(String uid, String id,
      {bool remove = false, String img, String join}) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.self['uid'])
        .collection('info')
        .document('friends')
        .setData({
      'friendList':
          remove ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid])
    }, merge: true);
    if (remove) {
      await jsonConverter.removeContent(uid: uid, key: 'id', where: id);
      friends.removeWhere((dat) => dat['id'] == id);
    } else {
      await jsonConverter.addContent(
          uid: uid, id: id, imgUrl: img, joinD: join);
      friends.add({'id': id, 'imgUrl': img, 'join': join});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (oldImg) {
          await friendManager.updateData(friendUID, index);
        }
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              friendUID == null
                  ? SizedBox()
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('Users')
                                .document(friendUID)
                                .collection('info')
                                .document(friendUID)
                                .snapshots(),
                            builder: (context, info) {
                              if (info.hasData &&
                                  info.connectionState ==
                                      ConnectionState.active) {
                                oldImg = img != info.data['img'];
                                return StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('Users')
                                        .document(friendUID)
                                        .snapshots(),
                                    builder: (context, acc) {
                                      if (acc.hasData &&
                                          acc.connectionState ==
                                              ConnectionState.active) {
                                        return Column(children: <Widget>[
                                          Container(
                                              color: Colors.black,
                                              width: a.width,
                                              // height: a.height / 7.2,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: a.width / 15,
                                                      right: a.width / 25,
                                                      left: a.width / 25,
                                                      bottom: a.width / 30.0),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            InkWell(
                                                                //back btn
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      a.width /
                                                                          7,
                                                                  height:
                                                                      a.width /
                                                                          10,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(a
                                                                              .width),
                                                                      color: Colors
                                                                          .white),
                                                                  child: Icon(
                                                                      Icons
                                                                          .arrow_back,
                                                                      color: Colors
                                                                          .black,
                                                                      size: a.width /
                                                                          15),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  if (oldImg) {
                                                                    await friendManager
                                                                        .updateData(
                                                                            friendUID,
                                                                            index);
                                                                  }
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                  return false;
                                                                }),
                                                            friends
                                                                        .where((dat) =>
                                                                            dat['id'] ==
                                                                            acc.data['id'])
                                                                        .length ==
                                                                    1
                                                                ? InkWell(
                                                                    //back btn
                                                                    child: Container(
                                                                        alignment: Alignment.center,
                                                                        width: a.width / 4,
                                                                        height: a.width / 9,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(a.width),
                                                                          border:
                                                                              Border.all(color: Colors.grey[600]),
                                                                          // color:
                                                                          //     Colors.white,
                                                                        ),
                                                                        child: Text(
                                                                          'ลบจากสหาย',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey[600],
                                                                            fontSize:
                                                                                a.width / 18,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        )),
                                                                    onTap:
                                                                        () async {
                                                                      await editFriend(
                                                                          acc.data[
                                                                              'uid'],
                                                                          acc.data[
                                                                              'id'],
                                                                          remove:
                                                                              true);
                                                                      Taoast().toast(
                                                                          "ลบ ${acc.data['id']} จากสหายแล้ว");
                                                                    },
                                                                  )
                                                                : InkWell(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          a.width /
                                                                              8,
                                                                      height:
                                                                          a.width /
                                                                              8,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(a
                                                                              .width),
                                                                          color:
                                                                              Colors.white),
                                                                      child: Icon(
                                                                          Icons
                                                                              .person_add,
                                                                          color: Colors
                                                                              .black,
                                                                          size: a.width /
                                                                              15),
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      await editFriend(
                                                                          acc.data[
                                                                              'uid'],
                                                                          acc.data[
                                                                              'id'],
                                                                          img: info.data[
                                                                              'img'],
                                                                          join:
                                                                              info.data['createdDay']);
                                                                      Taoast().toast(
                                                                          "เพิ่ม ${acc.data['id']} เป็นสหายแล้ว");
                                                                    },
                                                                  ),
                                                          ],
                                                        ), //back btn
                                                      ]))),
                                          Container(
                                            color: Colors.black,
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 20, right: 13),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a.width),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: a.width / 190)),
                                                width: a.width / 3.2,
                                                height: a.width / 3.2,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a.width),
                                                    child: CachedNetworkImage(
                                                      errorWidget: (context,
                                                          string, odject) {
                                                        return Image.asset(
                                                            'assets/userprofile.png',
                                                            fit: BoxFit.cover);
                                                      },
                                                      imageUrl:
                                                          info.data['img'],
                                                      fit: BoxFit.cover,
                                                    ))),
                                          ),
                                          SizedBox(
                                            height: a.width / 15,
                                          ),
                                          Text(
                                            "@${acc.data['id']}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: a.width / 12),
                                          ),
                                          Text(
                                            info.data['createdDay']
                                                        .runtimeType ==
                                                    String
                                                ? "Join ${info.data['createdDay']}"
                                                : "Join ${DateFormat('d/M/y').format(info.data['createdDay'].toDate())}",
                                            style: TextStyle(
                                                color: Color(0xff26A4FF),
                                                fontSize: a.width / 12),
                                          ),
                                          info?.data['status'] == null
                                              ? SizedBox(
                                                  height: a.width / 12,
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      top: a.width / 21),
                                                  child: SizedBox(
                                                    width: a.width / 1.6,
                                                    child: Text(
                                                      info.data['status'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          fontSize:
                                                              a.width / 16.5,
                                                          color: Colors.white,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  )),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: a.width / 15,
                                                right: a.width / 15),
                                            padding: EdgeInsets.only(
                                                top: a.width / 16),
                                            height: a.height / 5.6,
                                            //ใส่เส้นด้านใต้สุด
                                            child: Row(
                                              // ใส่ Row เพื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.black,
                                                  width: a.width / 4.5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    //เพื่อใช้สำหรับให้ จำนวน และ เขียน
                                                    children: <Widget>[
                                                      Text(
                                                        info?.data['written'] ==
                                                                null
                                                            ? '0'
                                                            : info
                                                                .data['written']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                a.width / 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "เขียน",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                a.width / 21),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.black,
                                                  width: a.width / 4.5,
                                                  margin: EdgeInsets.only(
                                                      left: a.width / 10,
                                                      right: a.width / 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        //เพื่อใช้สำหรับ��ห้ จำนวน และ ผ�����้หยิบอ่าน
                                                        info?.data['read'] ==
                                                                null
                                                            ? '0'
                                                            : info.data['read']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                a.width / 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "ผู้คนหยิบอ่าน",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                a.width / 21),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.black,
                                                  width: a.width / 4.5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    //เพื่อใช้สำหรับให้ จำนวน ��ละ โ��นปาใส��
                                                    children: <Widget>[
                                                      Text(
                                                        info?.data['threw'] ==
                                                                null
                                                            ? '0'
                                                            : info.data['threw']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                a.width / 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "โดนปาใส่",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                a.width / 21),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                              child: Container(
                                                width: a.width / 3.6,
                                                height: a.width / 3.6,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a.width),
                                                    border: Border.all(
                                                        color: Colors.white38,
                                                        width: a.width / 500)),
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                      a.width / 35),
                                                  width: a.width / 5,
                                                  height: a.width / 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              a.width),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Container(
                                                    margin: EdgeInsets.all(
                                                        a.width / 35),
                                                    width: a.width / 5,
                                                    height: a.width / 5,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    a.width),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    child: widget.data == null
                                                        ? Icon(
                                                            Icons.create,
                                                            size: a.width / 12,
                                                            color: Colors.black,
                                                          )
                                                        : Icon(
                                                            Icons.send,
                                                            size: a.width / 12,
                                                            color: Colors.black,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                widget.data == null
                                                    ? dialog(acc.data['id'],
                                                        acc.data['uid'])
                                                    : warnDialog(acc.data['id'],
                                                        acc.data['uid']);
                                              })
                                        ]);
                                      } else {
                                        return Loading();
                                      }
                                    });
                              } else {
                                return SizedBox();
                              }
                            }),
                      ),
                    ),
              loading ? Loading() : SizedBox()
            ],
          )),
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
                  if (await scraps.blocked(widget.self['uid'], thrownUID)) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    toast('คุณไม่สามารถปาไปหา"$user"ได้');
                  } else {
                    toast('ปาใส่"$user"แล้ว');
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    await scraps.throwTo(context,
                        uid: widget.self['uid'],
                        thrownUID: thrownUID,
                        text: widget.data['text'],
                        writer: widget.self['id']);
                  }
                },
              )
            ],
          );
        });
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

  dialog(String id, String uid) {
    var _key = GlobalKey<FormState>();
    DateTime now = DateTime.now();
    String time = DateFormat('Hm').format(now);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: a.height / 8,
                        right: a.width / 20,
                        left: 20,
                        bottom: a.width / 8),
                    child: ListView(
                      children: <Widget>[
                        //ออกจากหน้านี้
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: Icon(
                              Icons.clear,
                              size: a.width / 10,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        //���่ว��ของกระดาษ�������่เขี�����
                        Container(
                          margin: EdgeInsets.only(top: a.width / 50),
                          width: a.width / 1,
                          height: a.height / 1.8,
                          //ทำเ����นชั้นๆ
                          child: Stack(
                            children: <Widget>[
                              //ช���้นที่ 1 ส่วนของก���ะดาษ
                              Container(
                                child: Image.asset(
                                  'assets/paper-readed.png',
                                  width: a.width / 1,
                                  height: a.height / 1.8,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              //ชั้นที่ 2
                              Container(
                                margin: EdgeInsets.only(
                                    left: a.width / 20, top: a.width / 20),
                                width: a.width,
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "เขียนโดย : ",
                                          style: TextStyle(
                                              fontSize: a.width / 22,
                                              color: Colors.grey),
                                        ),
                                        Text("@${widget.self['id']}",
                                            style: TextStyle(
                                                fontSize: a.width / 22,
                                                color: Color(0xff26A4FF)))
                                      ],
                                    ),
                                    Text("เวลา" + " : " + time,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: a.width / 22))
                                  ],
                                ),
                              ),
                              //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
                              Container(
                                width: a.width,
                                height: a.height,
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  width: a.width,
                                  child: Form(
                                    key: _key,
                                    child: TextFormField(
                                      textAlign: TextAlign
                                          .center, //เพื่อให้ข้อความอยู่ตรงกลาง
                                      style: TextStyle(fontSize: a.width / 14),
                                      maxLines: null,
                                      maxLength: 250,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: InputBorder
                                            .none, //สำหรับใหเส้นใต้หาย
                                        hintText: 'เขียนข้อความบางอย่าง',
                                        hintStyle: TextStyle(
                                          height: 1.35,
                                          fontSize: a.width / 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      //หากไม่ได้กรอกจะขึ้น
                                      validator: (val) {
                                        return val.trim() == null ||
                                                val.trim() == ""
                                            ? Taoast().toast(
                                                "ลองเขียนข้อความบางอย่างสิ")
                                            : null;
                                      },
                                      //เนื้อหาที่กรอกเข้าไปใน text
                                      onChanged: (val) {
                                        text = val;
                                      },
                                    ),
                                  ),
                                ),
                              )
                              //)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: a.width / 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //ปุ่มปาใส่
                              InkWell(
                                child: Container(
                                  width: a.width / 4.5,
                                  height: a.width / 8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text("ปาเลย",
                                      style: TextStyle(
                                          fontSize: a.width / 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
                                onTap: () async {
                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();
                                    if (await scraps.blocked(
                                        widget.self['uid'], uid)) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      toast('คุณไม่สามารถปาไปหา"$id"ได้');
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                      // await scraps.throwTo(
                                      //     uid: widget.self['uid'],
                                      //     thrownUID: uid,
                                      //     text: text,
                                      //     writer: widget.self['id']);
                                      Taoast().toast('ปาใส่"$id"แล้ว');
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        )
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
