import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scrap/function/toDatabase/phoneAuthen.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/warning.dart';

class OTPScreen extends StatefulWidget {
  final String verifiedID;
  final String email;
  final String password;
  final String phone;
  final bool edit;
  OTPScreen(
      {@required this.verifiedID,
      @required this.phone,
      this.email,
      this.password,
      this.edit = false});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var _key = GlobalKey<FormState>();
  String otpCode, newVerified, token;
  bool loading = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<void> resend() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      print(id.toString() + " sent and " + resendCode.toString());
      newVerified = id;
    };
    final PhoneVerificationCompleted success =
        (AuthCredential credent) async {};
    PhoneVerificationFailed failed = (AuthException error) {
      print(error.message);
      Dg().warning(context, 'เกิดข้อผิดพลาดไม่ทราบสาเหตุกรุณาลองใหม่', "เกิดข้อผิดพลาด");
    };
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: '+66' + widget.phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      Dg().warning(context, 'เกิดข้อผิดพลาดไม่ทราบสาเหตุกรุณาลองใหม่', "เกิดข้อผิดพลาด");
      print(e.toString());
    });
  }

  register() async {
    try {
      Register register = Register(
          email: widget.email,
          phone: widget.phone,
          password: widget.password,
          token: token);
      await register.registerWithPhone(
          newVerified ?? widget.verifiedID, otpCode);
      setState(() {
        loading = false;
      });
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Authen()));
    } catch (e) {
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_VERIFICATION_CODE, The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user., null)':
          Dg().warning(context, 'กรุณาเช็ครหัสOTPของท่าน', "เกิดข้อผิดพลาด");
          break;
        default:
         Dg().warning(context,
              'เกิดข้อผิดพลาด OTP อาจหมดเวลาและกรุณาเช็คการเชื่อต่อของคุณ', "เกิดข้อผิดพลาด");
          break;
      }
      print(e.toString());
    }
  }

  login() {
    PhoneLogin()
        .loginWithOTP(newVerified ?? widget.verifiedID, otpCode)
        .then((_) {
      setState(() {
        loading = false;
      });
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Authen()));
    }).catchError((e) {
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_VERIFICATION_CODE, The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user., null)':
          Dg().warning(context, 'กรุณาเช็ครหัสOTPของท่าน', "เกิดข้อผิดพลาด");
          break;
        default:
          Dg().warning(context,
              'เกิดข้อผิดพลาด OTP อาจหมดเวลาและกรุณาเช็คการเชื่อต่อของคุณ', "เกิดข้อผิดพลาด");
          break;
      }
    });
  }

  changePhone() async {
    var authCredential = PhoneAuthProvider.getCredential(
        verificationId: newVerified ?? widget.verifiedID, smsCode: otpCode);
    var user = await FirebaseAuth.instance.currentUser();
    await user.updatePhoneNumberCredential(authCredential).then((value) async {
      await Firestore.instance
          .collection('Users')
          .document(user.uid)
          .updateData({'phone': widget.phone});
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Authen()));
    }).catchError((e) {
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_VERIFICATION_CODE, The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user., null)':
          Dg().warning(context, 'กรุณาเช็ครหัสOTPของท่าน', "เกิดข้อผิดพลาด");
          break;
        default:
          Dg().warning(context,
              'เกิดข้อผิดพลาด OTP อาจหมดเวลาและกรุณาเช็คการเชื่อต่อของคุณ', "เกิดข้อผิดพลาด");
          break;
      }
    });
  }

  toDb(String uid) async {
    await Firestore.instance.collection('Users').document(uid).setData({
      'email': widget.email,
      'password': widget.password,
      'phone': widget.phone,
      'uid': uid,
      'accept': false
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('recently')
        .setData({});
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('collection')
        .setData({});
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('notification')
        .setData({});
  }

  addToken(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('token')
        .document(token)
        .setData({'token': token});
  }

  void getToken() {
    firebaseMessaging.getToken().then((String tken) {
      assert(tken != null);
      token = tken;
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => warning2(context,
          'การดำเนินการจะไม่เสร็จสมบูรณ์คุณต้องการออกจากหน้านี้ใช่หรือไม่'),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(a.width / 20),
                child: Form(
                  key: _key,
                  child: Container(
                      width: a.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: a.width / 7,
                            height: a.width / 10,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Colors.white),
                                child: Icon(Icons.arrow_back,
                                    color: Colors.black, size: a.width / 15),
                              ),
                              onTap: () {
                                warning2(context,
                                    'การดำเนินการจะไม่เสร็จสมบูรณ์คุณต้องการออกจากหน้านี้ใช่หรือไม่');
                              },
                            ),
                          ),
                          Container(
                              width: a.width,
                              margin: EdgeInsets.only(top: a.width / 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "ยืนยันตัวตน",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: a.width / 8),
                                  ),
                                  Container(
                                    width: a.width / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: TextFormField(
                                      maxLength: 6,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: a.width / 10,
                                        color: Colors.white,
                                        letterSpacing: 10,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '******',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (val) {
                                        return val.trim() == "" ||
                                                val.trim().length < 6
                                            ? 'กรุณากรอกเลข 6 หลัก'
                                            : null;
                                      },
                                      onSaved: (val) => otpCode = val,
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'โปรดใส่รหัสยืนยันที่ได้รับจากทาง SMS\nหากไม่ได้รับ SMS ขอให้ดำเนินการตามวิธิต่อไปนี้',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 19,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      FlatButton(
                                        child: Text(
                                          'ส่งรหัสยืนยันอีกครั้ง',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 19,
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.underline),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: () async {
                                          await resend();
                                        },
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: a.width / 10),
                                      width: a.width / 1.5,
                                      height: a.width / 6,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                      child: Text(
                                        "ยืนยัน",
                                        style: TextStyle(
                                            fontSize: a.width / 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        setState(() {
                                          loading = true;
                                        });
                                        widget.email != null
                                            ? await register()
                                            : widget.edit
                                                ? await changePhone()
                                                : await login();
                                      } else {
                                        print('nope');
                                      }
                                    },
                                  ),
                                ],
                              ))
                        ],
                      )),
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          )),
    );
  }

  warning2(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "คุณต้องการออกจากหน้านี้ใช่หรือไม่",
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
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  
}
