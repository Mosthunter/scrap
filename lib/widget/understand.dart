import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';

class Understand extends StatefulWidget {
  @override
  _UnderstandState createState() => _UnderstandState();
}

class _UnderstandState extends State<Understand> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Understand'),
            onTap: () {
              _showdialogunderstand(context);
            },
          ),
        ),
      ),
    );
  }
}

void _showdialogunderstand(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        screenutilInit(context);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            margin: EdgeInsets.only(
                top: a.width / 10,
                right: a.width / 20,
                left: a.width / 20,
                bottom: a.width / 5),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: appBarHeight,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff282828),
                      borderRadius: BorderRadius.circular(a.width / 50)),
                  width: a.width,
                  padding: EdgeInsets.all(a.width / 50),
                  height: a.height / 1.7,
                  child: Scaffold(
                    backgroundColor: Color(0xff282828),
                    body: Container(
                      width: a.width,
                      height: a.height,
                      padding: EdgeInsets.only(
                          top: a.width / 10, bottom: a.width / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.group,
                            color: Color(0xff8B8B8B),
                            size: a.width / 2.5,
                          ),
                          Text(
                            'เปิดรับสแครปจากผู้ใช้งานรายอื่น',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: a.width / 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: appBarHeight / 3),
                          Text(
                            'คุณอาจได้รับสแครปไม่พึงประสงค์\nหากสแครปใดมีเนื้อหาผิดต่อสัญญาของเรา\nคุณสามารถรายงานปัญหามาที่เราได้ทุกเมื่อ ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: a.width / 20, color: Colors.white),
                          ),
                          SizedBox(height: appBarHeight / 2),
                          RaisedButton(
                              color: Color(0xff0099FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                width: a.width / 3.5,
                                height: a.width / 8.5,
                                alignment: Alignment.center,
                                child: Text(
                                  "เข้าใจแล้ว",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
