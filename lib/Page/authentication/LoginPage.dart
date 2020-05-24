import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/LoginID.dart';
import 'package:scrap/Page/authentication/OTPScreen.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/friendManager.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  var _key = GlobalKey<FormState>();
  FriendManager friendManager = FriendManager();
  StreamSubscription loadStatus;

  @override
  void initState() {
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: screenHeightDp / 4.8),
                    Text('เข้าสู่ระบบด้วยเบอร์โทรศัพท์',
                        style: TextStyle(
                            fontSize: s52,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: screenHeightDp / 27),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenWidthDp / 11.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                                height: screenHeightDp / 12,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.8, color: Colors.white),
                                    borderRadius: BorderRadius.circular(
                                        screenWidthDp / 42)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/thailand-flag-icon.jpg',
                                      width: screenWidthDp / 18,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 6.4),
                                    Text('+66',
                                        style: TextStyle(
                                            fontSize: s65, color: Colors.white))
                                  ],
                                )),
                          ),
                          SizedBox(width: screenWidthDp / 26),
                          Expanded(
                            flex: 2,
                            child: Form(
                              key: _key,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidthDp / 32),
                                height: screenHeightDp / 12,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.8, color: Colors.white),
                                    borderRadius: BorderRadius.circular(
                                        screenWidthDp / 42)),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  validator: (val) {
                                    var trim = val.trim();
                                    return trim == ''
                                        ? toast
                                            .validateToast('ใส่เบอร์โทรของคุณ')
                                        : trim.length != 10
                                            ? toast.validateToast(
                                                'ใส่เบอร์โทร10หลัก')
                                            : null;
                                  },
                                  style: TextStyle(
                                      height: 1.12,
                                      fontSize: s65,
                                      color: Colors.white),
                                  decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0.0),
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: s60,
                                          height: 1.12,
                                          color:
                                              Colors.white.withOpacity(0.24)),
                                      hintText: 'เบอร์โทร 10 หลัก'),
                                  onSaved: (val) {
                                    user.phone = val.trim();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeightDp / 27),
                    Text(
                      'เราจะส่งเลข 6 หลัก เพื่อยืนยันเบอร์คุณ',
                      style: TextStyle(color: Colors.white, fontSize: s46),
                    ),
                    SizedBox(height: screenHeightDp / 21),
                    GestureDetector(
                      child: Container(
                          width: screenWidthDp / 1.2,
                          height: screenWidthDp / 6.8,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: screenWidthDp / 22,
                              bottom: screenWidthDp / 35),
                          decoration: BoxDecoration(
                              color: Color(0xff26A4FF),
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp / 2)),
                          child: Text('ต่อไป',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: s58,
                              ))),
                      onTap: () {
                        var curState = _key.currentState;
                        if (curState.validate()) {
                          curState.save();
                          authService.phoneAuthentication(context);
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SignUpMail()));
                      },
                    ),
                    SizedBox(height: screenHeightDp / 54),
                    GestureDetector(
                        child: Text(
                          'ใช้ไอดีของ SCRAP.',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: s52,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          // authService.signOut(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginID()));
                        }),
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }
}
