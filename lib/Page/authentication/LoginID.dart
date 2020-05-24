import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/friendManager.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class LoginID extends StatefulWidget {
  @override
  _LoginIDState createState() => _LoginIDState();
}

class _LoginIDState extends State<LoginID> {
  String id, _password;
  bool loading = false;
  StreamSubscription loadingStream;
  var _key = GlobalKey<FormState>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    loadingStream =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadingStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: screenWidthDp / 4.2),
                      child: Text(
                        "เข้าสู่ระบบด้วยไอดี",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: s70,
                            fontFamily: 'ThaiSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                      key: _key,
                      child: Container(
                        margin: EdgeInsets.only(top: screenWidthDp / 15),
                        width: screenWidthDp / 1.15,
                        padding: EdgeInsets.only(bottom: screenWidthDp / 20),
                        decoration: BoxDecoration(
                            color: Color(0xff2B2B2B),
                            borderRadius:
                                BorderRadius.circular(screenWidthDp / 20)),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: screenWidthDp,
                                padding: EdgeInsets.only(
                                    top: screenWidthDp / 20,
                                    left: screenWidthDp / 20,
                                    bottom: screenWidthDp / 80),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: screenWidthDp / 22,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'ไอดี',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidthDp / 20,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              width: screenWidthDp / 1.3,
                              height: screenWidthDp / 6.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp)),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidthDp / 15,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '@someone',
                                  errorStyle: TextStyle(height: 0),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: screenWidthDp / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast().validateToast("ใส่ไอดีของคุณ")
                                      : null;
                                },
                                onSaved: (val) {
                                  var trim = val.trim();
                                  trim[0] == '@'
                                      ? id = trim.substring(1)
                                      : id = trim;
                                },
                              ),
                            ),
                            Container(
                              width: screenWidthDp,
                              padding: EdgeInsets.only(
                                  top: screenWidthDp / 20,
                                  left: screenWidthDp / 20,
                                  bottom: screenWidthDp / 80),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.lock,
                                      color: Colors.white,
                                      size: screenWidthDp / 22),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'รหัสผ่าน',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidthDp / 20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidthDp / 1.3,
                              height: screenWidthDp / 6.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp)),
                              child: TextFormField(
                                obscureText: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 10,
                                  fontSize: screenWidthDp / 15,
                                ),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 0),
                                  border: InputBorder.none,
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: screenWidthDp / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast()
                                          .validateToast('ใส่รหัสผ่านของคุณ')
                                      : null;
                                },
                                onSaved: (val) {
                                  _password = val.trim();
                                },
                              ),
                            ),
                            InkWell(
                                child: Container(
                                    width: screenWidthDp / 1.3,
                                    height: screenWidthDp / 6.5,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        top: screenWidthDp / 15,
                                        bottom: screenWidthDp / 35),
                                    decoration: BoxDecoration(
                                        color: Color(0xff26A4FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff000000)
                                                .withOpacity(0.16),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.1,
                                            offset: Offset(0.0, 3.2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp / 40)),
                                    child: Text("เข้าสู่ระบบ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidthDp / 16,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                onTap: () {
                                  var curState = _key.currentState;
                                  if (curState.validate()) {
                                    curState.save();
                                    authService.signInWithID(context,
                                        id: id, password: _password);
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeightDp / 27),
                    GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.white, size: s52),
                            Text(
                              ' เข้าสู่ระบบด้วยเบอร์โทรศัพท์',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }),
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ]));
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "เกิดข้อผิดพลาด",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
