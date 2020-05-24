import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrap/Page/Search.dart';
import 'package:scrap/Page/viewprofile.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';

class FriendList extends StatefulWidget {
  final DocumentSnapshot doc;
  final Map data;
  FriendList({@required this.doc, this.data});
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  String id;
  var _key = GlobalKey<FormState>();
  List friends = [];
  List searchResault = [];
  bool loading = true;
  List updatedFriends = [];
  Scraps scraps = Scraps();
  JsonConverter jsonConverter = JsonConverter();

  @override
  void initState() {
    initFriend();
    super.initState();
  }

  initFriend() async {
    friends = await jsonConverter.readContents();
    loading = false;
    setState(() {});
  }

  updateFriends() async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document('friends')
        .get()
        .then((doc) {
      updatedFriends = doc['friendList'] ?? [];
    });
  }

  updateData() async {
    List fID = [];
    for (String uid in updatedFriends) {
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((doc) async {
        await getInfo(fID, uid, doc.data['id']);
      });
    }
    await jsonConverter.writeContent(listm: fID);
  }

  getInfo(List list, String uid, String name) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((doc) async {
      list.add(
          {'id': name, 'img': doc.data['img'], 'join': doc.data['createdDay']});
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
                    bottom: a.width / 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
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
                                    color: Colors.black, size: a.width / 15),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            widget.data == null
                                ? Container(
                                    height: a.width / 10,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: Container(
                                        width: a.width / 10,
                                        height: a.width / 10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          color: Color(0xff26A4FF),
                                        ),
                                        child: Icon(Icons.person_add,
                                            color: Colors.white,
                                            size: a.width / 15),
                                      ),
                                      onTap: () async {
                                        bool resault = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Search(
                                                      doc: widget.doc,
                                                    ))); //ไปยังหน้า Search
                                        if (resault) {
                                          initFriend();
                                        }
                                      },
                                    ))
                                : Container(
                                    height: a.width / 10,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: Container(
                                        width: a.width / 10,
                                        height: a.width / 10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          color: Color(0xff26A4FF),
                                        ),
                                        child: Icon(Icons.people,
                                            color: Colors.white,
                                            size: a.width / 15),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Search(
                                                      doc: widget.doc,
                                                      data: widget.data,
                                                    ))); //ไปยังหน้า Search
                                      },
                                    )),
                          ],
                        ), //back btn
                        SizedBox(
                          height: a.height / 12.5,
                        ),
                        Container(
                          width: a.width / 1.17,
                          margin: EdgeInsets.only(left: a.width / 15),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'มิตรสหาย',
                                style: TextStyle(
                                    fontSize: a.width / 6.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'ค้นหาสหายแล้วปาสแครปใส่พวกเขากัน',
                                style: TextStyle(
                                    fontSize: a.width / 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: a.width / 13,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 5,
                            bottom: 30,
                          ),
                          width: a.width / 1.17,
                          height: a.width / 6.5,
                          decoration: BoxDecoration(
                            color: Color(0xff282828),
                            borderRadius:
                                BorderRadius.all(Radius.circular(300)),
                            border:
                                Border.all(width: 2, color: Colors.grey[800]),
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 14,
                              fontWeight: FontWeight.w300,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '@สหาย',
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                            onChanged: (val) {
                              Future.delayed(const Duration(milliseconds: 200),
                                  () async {
                                id = val.trim();
                                if (id?.length != null && id.length > 1) {
                                  searchResault = await jsonConverter
                                      .searchContents(id: id.substring(1));
                                }
                                setState(() {});
                              });
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                    friends?.length == null || friends.length == 0
                        ? guide(a, 'คุณไม่มีสหาย', a.height / 2.5)
                        : id == null || id == '' || id.length < 2
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: a.width / 55,
                                      left: a.width / 55,
                                    ),
                                    child: listFriend(
                                        a, friends.take(3).toList(),
                                        recom: true),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: a.width / 15,
                                      // bottom: a.width / 15,
                                    ),
                                    child: FlatButton(
                                      child: Text(
                                        'สหายทั้งหมด ${friends.length} คน',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 14),
                                      ),
                                      onPressed: () async {
                                        if (widget.data == null) {
                                          bool resault = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllFriends(
                                                        doc: widget.doc,
                                                      )));
                                          if (resault) {
                                            initFriend();
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          bool resault = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllFriends(
                                                        doc: widget.doc,
                                                        scrap: widget.data,
                                                      )));
                                          if (resault) {
                                            initFriend();
                                          }
                                        }
                                      },
                                    ),
                                  )
                                ],
                              )
                            : search(a)
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

  Widget search(Size a) {
    return searchResault.length == 0
        ? guide(a, 'ไม่พบไอดีนี้ในสหายของคุณ', a.height / 2.5)
        : listFriend(a, searchResault);
  }

  Widget listFriend(Size a, List resault, {bool recom = false}) {
    recom ? resault.shuffle() : null;
    return resault == null
        ? SizedBox()
        : Column(
            children: resault.map((friend) => cardStream(a, friend)).toList(),
          );
  }

  dynamic backward(List list, dynamic value) {
    return list[list.length - 1 - list.indexOf(value)];
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

  Widget cardStream(Size a, Map data) {
    return userCard(a, data['img'], data['id'], data['join']);
  }

  Widget userCard(Size a, String img, String throwID, String created,
      {DocumentSnapshot infoDoc, DocumentSnapshot accDoc}) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.5, left: 5.0, right: 5.0),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: a.width / 30,
              ),
              height: a.height / 5.5,
              width: a.width,
              decoration: BoxDecoration(
                  color: Color(0xff282828),
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              right: 15,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(a.width),
                                border: Border.all(
                                    color: Colors.white, width: a.width / 190)),
                            width: a.width / 5,
                            height: a.width / 5,
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                errorWidget: (context, string, odject) {
                                  return Image.asset('assets/userprofile.png',
                                      fit: BoxFit.cover);
                                },
                                imageUrl: img,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(a.width),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: a.width / 2.8,
                                height: a.height / 18,
                                child: Text(
                                  '@$throwID',
                                  style: TextStyle(
                                      fontSize: a.width / 13,
                                      color: Colors.white),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Join $created',
                                    style: TextStyle(
                                        fontSize: a.width / 16,
                                        color: Color(0xff26A4FF)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 2),
                        width: a.width / 6.2,
                        height: a.width / 6.2,
                        decoration: BoxDecoration(
                            // color: Colors.orange,
                            borderRadius: BorderRadius.circular(a.width),
                            border: Border.all(
                                color: Colors.white24, width: a.width / 500)),
                        child: Container(
                          margin: EdgeInsets.all(a.width / 75),
                          width: a.width / 7.5,
                          height: a.width / 7.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              border: Border.all(color: Colors.white70)),
                          child: Container(
                            margin: EdgeInsets.all(a.width / 70),
                            width: a.width / 7.5,
                            height: a.width / 7.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(a.width),
                                color: Colors.white,
                                border: Border.all(color: Colors.white)),
                            child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                  widget.data == null
                                      ? Icons.create
                                      : Icons.send,
                                  size: a.width / 21,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Viewprofile(
                                          id: throwID,
                                          self: widget.doc,
                                          data: widget.data),
                                    ));
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
        onTap: () async {
          bool resault = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Viewprofile(
                    id: throwID, self: widget.doc, data: widget.data),
              )); //ไปยังหน้า Search
          if (resault) {
            initFriend();
          }
        },
      ),
    );
  }

  warnDialog(String user, DocumentSnapshot accDoc) {
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
                  scraps.throwTo(context,
                      uid: widget.doc['uid'],
                      writer: widget.doc['id'],
                      thrownUID: accDoc['uid'],
                      text: widget.data['text']);
                  toast('ปาใส่${accDoc['id']}แล้ว');
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
        //timeInSecForIos: 1,
        backgroundColor: Colors.white60,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

class AllFriends extends StatefulWidget {
  final DocumentSnapshot doc;
  final Map scrap;
  AllFriends({@required this.doc, this.scrap});
  @override
  _AllFriendsState createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {
  List display = [];
  List sortedList = [];
  List friends = [];
  ScrollController scrollController = ScrollController();
  JsonConverter jsonConverter = JsonConverter();

  @override
  void initState() {
    initFriend(5);
    initScroller();
    super.initState();
  }

  initFriend(int take) async {
    friends = await jsonConverter.readContents();
    display = friends.reversed.take(take).toList();
    sortedList = friends.reversed.toList();
    setState(() {});
  }

  initScroller() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (display.length != sortedList.length) {
          for (int i = display.length;
              sortedList.length - display.length < 6
                  ? i < sortedList.length
                  : i < display.length + 6;
              i++) {
            display.add(sortedList[i]);
          }
          setState(() {});
          scrollController.animateTo(210,
              duration: Duration(milliseconds: 500),
              curve: Curves.linearToEaseOut);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: a.width / 24, left: a.width / 24),
                child: InkWell(
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
                    Navigator.pop(context, true);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: a.width / 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      'สหาย',
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 15),
                    ),
                    Text(
                      ' ${sortedList.length.toString()} คน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: a.width / 11,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemExtent: a.height / 5.6,
                      children:
                          display.map((data) => cardStream(a, data)).toList()))
            ],
          ),
        ),
      ),
    );
  }

  Widget cardStream(Size a, Map data) {
    return Center(child: userCard(a, data['img'], data['id'], data['join']));
  }

  Widget userCard(Size a, String img, String throwID, String created,
      {DocumentSnapshot infoDoc, DocumentSnapshot accDoc}) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: a.width / 21),
            height: a.height / 5.6,
            width: a.width / 1.1,
            decoration: BoxDecoration(
                color: Color(0xff282828),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                )),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width),
                              border: Border.all(
                                  color: Colors.white, width: a.width / 190)),
                          width: a.width / 4.8,
                          height: a.width / 4.8,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              errorWidget: (context, string, odject) {
                                return Image.asset('assets/userprofile.png',
                                    fit: BoxFit.cover);
                              },
                              imageUrl: img,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(a.width),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: a.width / 2.8,
                              height: a.height / 18,
                              child: Text(
                                '@$throwID',
                                style: TextStyle(
                                    fontSize: a.width / 13,
                                    color: Colors.white),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Join $created',
                                  style: TextStyle(
                                      fontSize: a.width / 16,
                                      color: Color(0xff26A4FF)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: a.width / 6.4,
                      height: a.width / 6.4,
                      decoration: BoxDecoration(
                          // color: Colors.orange,
                          borderRadius: BorderRadius.circular(a.width),
                          border: Border.all(
                              color: Colors.white24, width: a.width / 500)),
                      child: Container(
                        margin: EdgeInsets.all(a.width / 75),
                        width: a.width / 7.5,
                        height: a.width / 7.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            border: Border.all(color: Colors.white70)),
                        child: Container(
                          margin: EdgeInsets.all(a.width / 70),
                          width: a.width / 7.5,
                          height: a.width / 7.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              color: Colors.white,
                              border: Border.all(color: Colors.white)),
                          child: IconButton(
                              icon: Icon(
                                  widget.scrap == null
                                      ? Icons.create
                                      : Icons.send,
                                  size: a.width / 21,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Viewprofile(
                                          id: throwID,
                                          self: widget.doc,
                                          data: widget.scrap),
                                    ));
                              }),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
      onTap: () async {
        bool resault = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Viewprofile(
                  id: throwID, self: widget.doc, data: widget.scrap),
            )); //ไปยังหน้า Search
        if (resault) {
          initFriend(display.length);
        }
      },
    );
  }
}
