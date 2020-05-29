import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Ads.dart';

class Paperstranger extends StatefulWidget {
  @override
  _PaperstrangerState createState() => _PaperstrangerState();
}

class _PaperstrangerState extends State<Paperstranger> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: appBarHeight / 5),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Container(
                          child: Center(
                              child: Text(
                            'เบื่อไอป้อม',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: s52),
                          )),
                          /*  height: 407 * appBarHeight / 75,
                          width: 365 * appBarHeight / 75,*/
                          height: screenWidthDp / 1.05 * 1.21,
                          width: screenWidthDp / 1.05,
                          color: Colors.white,
                        )),
                        Positioned(
                            right: 0,
                            child: Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Color(0xfff707070),
                                  size: s70,
                                ),
                                onPressed: () {
                                  nav.pop(context);
                                },
                              ),
                              //color: Colors.yellow,
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: appBarHeight / 10,
                ),
                Container(
                  height: appBarHeight * 1,
                  width: screenWidthDp,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: appBarHeight / 7,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: appBarHeight / 8,
                                ),
                                Text(
                                  '@MIKE',
                                  style: TextStyle(
                                      color: Color(0xfff26A4FF), fontSize: s52),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'เหลือเวลาอีก :',
                                      style:
                                          TextStyle(color: Color(0xfff969696)),
                                    ),
                                    Text(
                                      '\t23:47:01',
                                      style: TextStyle(
                                          color: Color(0xfffFFFFFF),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                          top: appBarHeight / 8,
                          right: appBarHeight / 7,
                          child: Container(
                            child: GestureDetector(
                              child: Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: s70 * 1.2,
                              ),
                              onTap: () {},
                            ),
                          )),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Color(0xff5D5D5D)),
                    ),
                  ),
                ),
                /* Divider(
                  color: Colors.grey,
                ),*/
                SizedBox(
                  height: appBarHeight / 10,
                ),
                Container(
                  width: screenWidthDp,
                  height: appBarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: appBarHeight / 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(appBarHeight / 8),
                          /* child: IconButton(
                              icon: Icon(
                                Icons.move_to_inbox,
                                size: s60 * 1.2,
                                color: Color(0xfff0099FF),
                              ),
                              onPressed: () {}),*/
                          child: GestureDetector(
                            child: Icon(
                              Icons.move_to_inbox,
                              color: Color(0xfff0099FF),
                            ),
                          ),
                          /*  height: appBarHeight / 1.8,
                          width: appBarHeight / 1.8,*/

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                          )),
                      SizedBox(
                        width: appBarHeight / 5,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.only(
                                left: appBarHeight / 5,
                                right: appBarHeight / 5,
                                top: appBarHeight / 8,
                                bottom: appBarHeight / 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.reply,
                                  //  size: s60 * 1.2,
                                  color: Colors.white,
                                ),
                                Text('ปากลับ',
                                    style: TextStyle(
                                      fontSize: s42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            /*  height: appBarHeight / 1.8,
                            //width: appBarHeight / 1.8,
                            width: appBarHeight * 1.5,*/
                            decoration: BoxDecoration(
                              color: Color(0xfff26A4FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            )),
                      ),
                    ],
                  ),
                ),
                /* Container(
                  height: appBarHeight,
                  width: screenWidthDp,
                  child: Stack(children: <Widget>[
                    Positioned(
                        left: appBarHeight / 5,
                        child: Container(
                            child: IconButton(
                                icon: Icon(
                                  Icons.move_to_inbox,
                                  size: s60 * 1.2,
                                  color: Color(0xfff0099FF),
                                ),
                                onPressed: () {}),
                            height: appBarHeight / 1.5,
                            width: appBarHeight / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ))),
                    Positioned(
                        left: appBarHeight * 1.05,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.reply,
                                    size: s60 * 1.2,
                                    color: Colors.white,
                                  ),
                                  Text('ปากลับ',
                                      style: TextStyle(
                                        fontSize: s52,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                              height: appBarHeight / 1.5,
                              width: appBarHeight * 1.5,
                              decoration: BoxDecoration(
                                color: Color(0xfff26A4FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              )),
                        )),
                    Positioned(
                        left: appBarHeight * 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.forward,
                                      size: s60 * 1.2,
                                    ),
                                    onPressed: () {}),
                                height: appBarHeight / 1.5,
                                width: appBarHeight / 1.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                )),
                            SizedBox(
                              height: appBarHeight / 10,
                            ),
                            Text(
                              'ต่อไป',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s40,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ]),
                ),*/
              ]),
              Positioned(
                  bottom: 0,
                  child: Container(
                    child: Ads(),
                  )),
            ],
          ),
        ));
  }
}
