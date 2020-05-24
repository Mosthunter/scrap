import 'dart:io';
import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/friendList.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/warning.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String type, select, text;
  bool public = false, initInfoFinish = false;
  Scraps scrap = Scraps();
  JsonConverter jsonConverter = JsonConverter();

  // _showModalBottomSheet(context) {
  //   Size a = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (BuildContext context) {
  //         Size a = MediaQuery.of(context).size;
  //         return Stack(
  //           children: <Widget>[
  //             Container(
  //               child: Container(
  //                 width: a.width,
  //                 height: a.width / 1.8,
  //                 decoration: BoxDecoration(
  //                     color: Color(0xff282828),
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(a.width / 20),
  //                       topRight: Radius.circular(a.width / 20),
  //                     )),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Container(
  //                       margin: EdgeInsets.only(
  //                           top: a.width / 40, bottom: a.width / 15),
  //                       width: a.width / 3,
  //                       height: a.width / 50,
  //                       decoration: BoxDecoration(
  //                           color: Colors.grey,
  //                           borderRadius: BorderRadius.circular(a.width)),
  //                     ),
  //                     Container(
  //                       width: a.width,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           Column(
  //                             children: <Widget>[
  //                               InkWell(
  //                                 child: Container(
  //                                   margin:
  //                                       EdgeInsets.only(bottom: a.width / 50),
  //                                   width: a.width / 6,
  //                                   height: a.width / 6,
  //                                   child: Icon(
  //                                     Icons.whatshot,
  //                                     size: a.width / 13,
  //                                     color: Color(0xffFF8F3A),
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius:
  //                                         BorderRadius.circular(a.width),
  //                                   ),
  //                                 ),
  //                                 onTap: () {
  //                                   //ต้องแก้
  //                                   //  _showdialogwhatshot(context);
  //                                 },
  //                               ),
  //                               Text(
  //                                 "เผากระดาษ",
  //                                 style: TextStyle(color: Colors.white),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             width: a.width / 10,
  //                           ),
  //                           InkWell(
  //                             child: Column(
  //                               children: <Widget>[
  //                                 Container(
  //                                   margin:
  //                                       EdgeInsets.only(bottom: a.width / 50),
  //                                   width: a.width / 6,
  //                                   height: a.width / 6,
  //                                   child: Icon(
  //                                     Icons.block,
  //                                     size: a.width / 13,
  //                                     color: Color(0xff8B8B8B),
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.white,
  //                                       borderRadius:
  //                                           BorderRadius.circular(a.width)),
  //                                 ),
  //                                 Text(
  //                                   "บล็อคผู้ใช้",
  //                                   style: TextStyle(color: Colors.white),
  //                                 )
  //                               ],
  //                             ),
  //                             onTap: () {
  //                               //ต้องแก้
  //                               //   _showdialogblock(context);
  //                             },
  //                           ),
  //                           SizedBox(
  //                             width: a.width / 10,
  //                           ),
  //                           InkWell(
  //                             child: Column(
  //                               children: <Widget>[
  //                                 Container(
  //                                   margin:
  //                                       EdgeInsets.only(bottom: a.width / 50),
  //                                   width: a.width / 6,
  //                                   height: a.width / 6,
  //                                   child: Icon(
  //                                     Icons.report_problem,
  //                                     size: a.width / 13,
  //                                     color: Color(0xff8B8B8B),
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.white,
  //                                       borderRadius:
  //                                           BorderRadius.circular(a.width)),
  //                                 ),
  //                                 Text(
  //                                   "รายงาน",
  //                                   style: TextStyle(color: Colors.white),
  //                                 )
  //                               ],
  //                             ),
  //                             onTap: () {
  //                               //ต้องแก้
  //                               // _showdialogreport(context);
  //                               // _showdialogreport(context);
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 0,
  //               child: AdmobBanner(
  //                   adUnitId: AdmobService().getBannerAdId(),
  //                   adSize: AdmobBannerSize.FULL_BANNER),
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  void initState() {
    Admob.initialize(AdmobService().getAdmobAppId());
    initUser();
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdmobService().getAdmobAppId());
  }

  initUser() async {
    final user = Provider.of<UserData>(context, listen: false);
    var data = await userinfo.readContents();
    user.img = data['img'];
    user.id = data['id'];
    setState(() => initInfoFinish = true);
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    final user = Provider.of<UserData>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Dg().warnDialog(context, 'คุณต้องการออกจากScrapใช่หรือไม่', () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: <Widget>[
            MapScraps(uid: user.uid),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: a.width,
                child: Column(
                  children: [
                    Container(
                      // ส่วนของ แทบสีดำด้านบน
                      color: Colors.black,
                      width: a.width,
                      height: a.width / 5,
                      padding: EdgeInsets.only(
                        top: a.height / 36,
                        right: a.width / 20,
                        left: a.width / 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Logo
                          Container(
                              margin: EdgeInsets.only(top: a.width / 90),
                              height: a.width / 7,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/SCRAP.png',
                                width: a.width / 4,
                              )),
                          //��่วนของ UI ปุ่ม account เพื่อไปหน้า Profile
                          SizedBox(width: a.width / 4.7),
                          Container(
                              height: a.width / 5,
                              alignment: Alignment.center,
                              child: InkWell(
                                child: Container(
                                  width: a.width / 10,
                                  height: a.width / 10,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Colors.pink,
                                  ),
                                  child: Icon(Icons.favorite,
                                      color: Colors.white, size: a.width / 15),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Gridfavorite()));
                                },
                              )),
                          Container(
                              height: a.width / 5,
                              alignment: Alignment.center,
                              child: InkWell(
                                child: Container(
                                  width: a.width / 10,
                                  height: a.width / 10,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Color(0xff26A4FF),
                                  ),
                                  child: Icon(Icons.people,
                                      color: Colors.white, size: a.width / 15),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FriendList(doc: null)));
                                },
                              )),
                          Container(
                              height: a.width / 5,
                              alignment: Alignment.center,
                              child: InkWell(
                                child: Container(
                                  width: a.width / 10,
                                  height: a.width / 10,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(a.width),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: initInfoFinish
                                      ? ClipRRect(
                                          child: Image.file(File(user.img),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(
                                              a.width / 10),
                                        )
                                      : Icon(Icons.person,
                                          color: Colors.black,
                                          size: a.width / 15),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Profile())); //ไปยังหน้า Profile
                                },
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: AdmobBanner(
                          adUnitId: AdmobService().getBannerAdId(),
                          adSize: AdmobBannerSize.FULL_BANNER),
                    )
                  ],
                ),
              ),
            ),
            // Positioned(
            //     // left: a.width/4.8,
            //     width: a.width,
            //     top: a.height / 7.2,
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           SizedBox(
            //             width: 1,
            //           ),
            //           scrapLeft(a),
            //           SizedBox(
            //             width: 1,
            //           )
            //         ])),
          ],
        ),
      ),
    );
  }

  // Widget changeScrap(String scraps, Size a) {
  //   switch (scraps) {
  //     case 'Analysts':
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //     case 'Diplomats':
  //       return scrapPatt(a, 'Diplomats');
  //       break;
  //     case 'Explorers':
  //       return scrapPatt(a, 'Explorers');
  //       break;
  //     case 'Girl':
  //       return scrapPatt(a, 'Girl');
  //       break;
  //     case 'Sentinels':
  //       return scrapPatt(a, 'Sentinels');
  //       break;
  //     default:
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //   }
  // }

/*
       Set id = {};
            List scraps = [];
            for (var usersID in snap.data['id']) {
              id.add(usersID);
              for (var scrap in snap.data['scraps'][usersID]) {
                scraps.add(scrap);
              } /Users/gPSC1TxFcXVVZ1nQOrPR2kX9SBU2/scraps/collection
            } */

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

  // void dialog1() {
  //   DateTime now = DateTime.now();
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         Size a = MediaQuery.of(context).size;
  //         return StatefulBuilder(builder: (context, StateSetter setState) {
  //           return Scaffold(
  //             backgroundColor: Colors.black,
  //             body: Stack(
  //               children: <Widget>[
  //                 InkWell(
  //                   child: Container(
  //                     width: a.width,
  //                     height: a.height,
  //                   ),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   child: AdmobBanner(
  //                       adUnitId: AdmobService().getBannerAdId(),
  //                       adSize: AdmobBannerSize.FULL_BANNER),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(
  //                       top: a.height / 8,
  //                       right: a.width / 20,
  //                       left: 20,
  //                       bottom: a.width / 8),
  //                   child: ListView(
  //                     children: <Widget>[
  //                       Form(
  //                         key: _key,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Container(
  //                               width: a.height,
  //                               alignment: Alignment.center,
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: <Widget>[
  //                                   //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
  //                                   Container(
  //                                     child: Row(
  //                                       children: <Widget>[
  //                                         Container(
  //                                           width: a.width / 13,
  //                                           height: a.width / 13,
  //                                           decoration: BoxDecoration(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(
  //                                                       a.width / 50),
  //                                               border: Border.all(
  //                                                   color: Colors.transparent)),
  //                                           child: Checkbox(
  //                                             value: public ?? false,
  //                                             onChanged: (bool value) {
  //                                               setState(() {
  //                                                 public = value;
  //                                               });
  //                                             },
  //                                           ),
  //                                         ),
  //                                         Container(
  //                                           child: Text(
  //                                             "\t" + "เปิดเผยตัวตน",
  //                                             style: TextStyle(
  //                                                 color: Colors.white,
  //                                                 fontSize: a.width / 20),
  //                                           ),
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   //ออกจาก��น้านี้
  //                                   InkWell(
  //                                     child: Icon(
  //                                       Icons.clear,
  //                                       size: a.width / 10,
  //                                       color: Colors.white,
  //                                     ),
  //                                     onTap: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             //ส่ว��ข���งกระดาษที่เขีย���
  //                             Container(
  //                               margin: EdgeInsets.only(top: a.width / 150),
  //                               width: a.width / 1,
  //                               height: a.height / 1.8,
  //                               //ทำเป���น�������ั้นๆ
  //                               child: Stack(
  //                                 children: <Widget>[
  //                                   //ช������้นที่ 1 ส่วนของก���ะดาษ
  //                                   Container(
  //                                     child: Image.asset(
  //                                       'assets/paper-readed.png',
  //                                       width: a.width / 1.04,
  //                                       height: a.width / 1.04 * 1.115,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   ),
  //                                   //ชั้นที่ 2
  //                                   Container(
  //                                     margin: EdgeInsets.only(
  //                                         left: a.width / 20,
  //                                         top: a.width / 20),
  //                                     width: a.width,
  //                                     alignment: Alignment.topLeft,
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: <Widget>[
  //                                         public ?? false
  //                                             ? Row(
  //                                                 children: <Widget>[
  //                                                   Text(
  //                                                     "เขียนโดย : ",
  //                                                     style: TextStyle(
  //                                                         fontSize:
  //                                                             a.width / 22,
  //                                                         color: Colors.grey),
  //                                                   ),
  //                                                   Text("@${widget.doc['id']}",
  //                                                       style: TextStyle(
  //                                                           fontSize:
  //                                                               a.width / 22,
  //                                                           color: Color(
  //                                                               0xff26A4FF)))
  //                                                 ],
  //                                               )
  //                                             : Text(
  //                                                 'เขียนโดย : ใครสักคน',
  //                                                 style: TextStyle(
  //                                                     fontSize: a.width / 22,
  //                                                     color: Colors.grey),
  //                                               ),
  //                                         Text(DateFormat('HH:mm').format(now),
  //                                             style: TextStyle(
  //                                                 color: Colors.grey,
  //                                                 fontSize: a.width / 22))
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
  //                                   Container(
  //                                     width: a.width,
  //                                     height: a.height,
  //                                     alignment: Alignment.center,
  //                                     child: Container(
  //                                       padding: EdgeInsets.only(
  //                                           left: 25, right: 25),
  //                                       width: a.width,
  //                                       child: TextFormField(
  //                                         maxLength: 250,
  //                                         textAlign: TextAlign.center,
  //                                         style: TextStyle(
  //                                             height: 1.35,
  //                                             fontSize: a.width / 14),
  //                                         maxLines: null,
  //                                         keyboardType: TextInputType.text,
  //                                         decoration: InputDecoration(
  //                                           counterText: "",
  //                                           counterStyle: TextStyle(
  //                                               color: Colors.transparent),
  //                                           border: InputBorder
  //                                               .none, //สำหรับใหเส้นใต้หาย
  //                                           hintText:
  //                                               'เขียนข้อความบางอย่างที่อยู่ในใจคุณ\nไม่ต้องห่วง มันจะหายไปใน 24 ชั่วโมง\n(แต่อย่าลืมสัญญาของเราล่ะ)',
  //                                           hintStyle: TextStyle(
  //                                             fontSize: a.width / 18,
  //                                             color: Colors.grey,
  //                                           ),
  //                                         ),
  //                                         //หากไม่ได้กรอกจะขึ้น
  //                                         validator: (val) {
  //                                           return val.trim() == null ||
  //                                                   val.trim() == ""
  //                                               ? Taoast().toast(
  //                                                   "ลองเขียนข้อความบางอย่างสิ")
  //                                               : null;
  //                                         },
  //                                         //เนื้อหาท��่กรอกเข้าไปใน text
  //                                         onChanged: (val) {
  //                                           text = val;
  //                                         },
  //                                       ),
  //                                     ),
  //                                   )
  //                                   //)
  //                                 ],
  //                               ),
  //                             ),
  //                             Container(
  //                               margin: EdgeInsets.only(top: a.width / 10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: <Widget>[
  //                                   InkWell(
  //                                       child: Container(
  //                                         width: a.width / 4.5,
  //                                         height: a.width / 8,
  //                                         decoration: BoxDecoration(
  //                                             color: Colors.white,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(
  //                                                     a.width / 30)),
  //                                         alignment: Alignment.center,
  //                                         child: Text("ปาใส่",
  //                                             style: TextStyle(
  //                                                 color: Color(0xff26A4FF),
  //                                                 fontSize: a.width / 15,
  //                                                 fontWeight: FontWeight.bold)),
  //                                       ),
  //                                       //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
  //                                       onTap: () {
  //                                         if (_key.currentState.validate()) {
  //                                           _key.currentState.save();

  //                                           Navigator.pop(context);
  //                                           Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                 builder: (context) =>
  //                                                     FriendList(
  //                                                   doc: widget.doc,
  //                                                   data: {'text': text},
  //                                                 ),
  //                                               ));
  //                                         }
  //                                       }),
  //                                 ],
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         });
  //       },
  //       fullscreenDialog: true));
  // }

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
