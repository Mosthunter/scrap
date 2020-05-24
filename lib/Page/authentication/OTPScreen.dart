import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/LoginID.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class OTPScreen extends StatefulWidget {
  final bool register;
  OTPScreen({this.register = false});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp = '';
  bool loading = false;
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
          Container(
            width: screenWidthDp,
            height: screenHeightDp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'ใส่เลข 6 หลักจาก SMS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: s52,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeightDp / 42),
                Container(
                  width: screenWidthDp / 1.16,
                  child: PinCodeTextField(
                      textInputType: TextInputType.number,
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(fontSize: s90, color: Colors.white),
                      pinTheme: PinTheme(
                          activeColor: Colors.white,
                          inactiveColor: Colors.white,
                          fieldWidth: screenWidthDp / 7.8,
                          fieldHeight: screenHeightDp / 12),
                      length: 6,
                      onChanged: (val) {
                        setState(() => otp = val.trim());
                      }),
                ),
                GestureDetector(
                  child: Container(
                      width: screenWidthDp / 1.42,
                      height: screenWidthDp / 6.8,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: screenHeightDp / 14.6),
                      decoration: BoxDecoration(
                          color: otp.length < 6
                              ? Color(0xff525252)
                              : Color(0xff26A4FF),
                          borderRadius:
                              BorderRadius.circular(screenWidthDp / 36)),
                      child: Text('เข้าสู่ระบบ',
                          style: TextStyle(
                            color:
                                otp.length < 6 ? Colors.white38 : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: s52,
                          ))),
                  onTap: () {
                    submitOTP();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SignUpMail()));
                  },
                ),
                SizedBox(height: screenHeightDp / 4.6),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginID()));
                    }),
                SizedBox(height: screenHeightDp / 12)
              ],
            ),
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  submitOTP() async {
    final user = Provider.of<UserData>(context, listen: false);
    var query =
        await authService.getDocuments('phone', user.phone, field: 'Users');
    var docs = query.documents;
    if (widget.register) {
      if (docs.length > 0) user.id = docs[0]['id'];

      authService.signUpWithPhone(context, smsCode: otp);
    } else
      authService.signInWithPhone(context, smsCode: otp);
  }
}
