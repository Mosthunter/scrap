import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/friendList.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';
import 'package:scrap/widget/warning.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Report_DropDownButton extends StatefulWidget {
  @override
  _Report_DropDownButtonState createState() => _Report_DropDownButtonState();
}

class _Report_DropDownButtonState extends State<Report_DropDownButton> {
  dynamic dropdownValue = 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ';

  @override
  Widget build(BuildContext context) {

    return DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        value: dropdownValue,
        dropdownColor: Color(0xfff282828),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: s60,
        onChanged: (dynamic newValue) {
          setState(
            () {
              final report = Provider.of<Report>(context, listen: false);
              report.topic = newValue;
              dropdownValue = newValue;
            },
          );
        },
        items: <dynamic>[
          'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ',
          'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ',
          'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ',
          'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ',
        ].map<DropdownMenuItem<dynamic>>((dynamic value) {
          if (value == 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else {}
        }).toList(),
      ),
    );
  }
}

class Showreport extends StatefulWidget {
  @override
  _ShowreportState createState() => _ShowreportState();
}

class _ShowreportState extends State<Showreport> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: InkWell(
          child: Text('Report'),
          onTap: () {
            showDialogReport(context);
          },
        ),
      ),
    );
  }
}

void showDialogReport(BuildContext context) {
  Size a = MediaQuery.of(context).size;
  final report = Provider.of<Report>(context, listen: false);

  getDate(){
    var now  = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  updateData() async {
    await Firestore.instance
    .collection("Report")
    .document(getDate())
    .collection("reportUser")
    .document()
    .setData({
      "topic":report.topic,
      "reporter":"wait for provider",
      "reported":"wait for provider",
      "text":report.reportText,
      "timestamp":DateTime.now().millisecondsSinceEpoch
    });
  }
  screenutilInit(context);
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: appBarHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: appBarHeight / 4, bottom: appBarHeight / 5),
                  child: GestureDetector(
                      child: Container(
                        height: appBarHeight / 2.8,
                        width: appBarHeight / 2.8,
                        decoration: BoxDecoration(
                            color: Color(0xfffFFFFFF).withOpacity(0.24),
                            borderRadius: BorderRadius.all(
                                Radius.circular(appBarHeight))),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: s42,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
            Container(
              height: screenHeightDp / 1.7,
              width: screenWidthDp / 1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: a.width / 100),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomPadding: false,
                      body: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfff282828),
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Report_DropDownButton(),
                            ),
                            Container(
                              /*  margin: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),*/
                              padding: EdgeInsets.only(
                                  top: a.width / 100, left: a.width / 50),
                              child: TextField(
                                onChanged: (str){
                                  final report = Provider.of<Report>(context, listen: false);
                                  report.reportText = str;
                                },
                                style: TextStyle(
                                    fontSize: s52, color: Colors.white),
                                minLines: 5,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  // fillColor: Colors.redAccent,
                                  // filled: true,
                                  border: InputBorder.none,
                                  hintText: 'รายงานเจ้าของสแครปรายนี้',
                                  hintStyle: TextStyle(
                                    fontSize: s54,
                                    height: 0.08,
                                    color: Colors.white30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: appBarHeight * 1.75,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    updateData();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: appBarHeight / 15),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: a.width / 40,
                                      vertical: a.width / 40,
                                    ),
                                    width: a.width / 8,
                                    height: a.width / 8,
                                    //alignment: Alignment.center,
                                    child: Icon(
                                      Icons.send,
                                      color: Color(0xff26A4FF),
                                      size: s60 * 0.8,
                                    ),

                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(a.width)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeightDp / 18,
                    ),
                    child: Divider(
                      color: Color(0xff383838),
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
}
