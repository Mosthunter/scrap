import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/Page/OTPScreen.dart';
import 'package:scrap/Page/signup/SignUpMail.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  var _key = GlobalKey<FormState>();

  login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authen()));
    } catch (e) {
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
          warning(context, 'กรุณาตรวจสอบ"อีเมล"ของท่าน');
          break;
        case 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)':
          warning(context, 'ไม่พบบัญชีผู้ใช้กรุณาตรวจสอบใหม่');
          break;
        case 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)':
          warning(context, 'กรุณาตรวจสอบรหัสผ่านของท่าน');
          break;
        case "'package:firebase_auth/src/firebase_auth.dart': Failed assertion: line 224 pos 12: 'email != null': is not true.":
          warning(context, 'กรุณากรอกอีเมลและรหัสผ่าน');
          break;
        default:
          warning(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อต่ออินเทอร์เน็ต');
          break;
      }
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "ยินดีต้อนรับ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: a.width / 9,
                    fontFamily: 'ThaiSans',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                "\"สู่โลกที่เต็มไปด้วยเศษกระดาษ\"",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: a.width / 18,
                  fontFamily: 'ThaiSans',
                ),
              ),
            ),
            Form(
              key: _key,
              child: Container(
                margin: EdgeInsets.only(top: a.width / 15),
                width: a.width / 1.15,
                padding: EdgeInsets.only(bottom: a.width / 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff595959),
                        Color(0xff292929),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(a.width / 20)),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: a.width,
                        padding: EdgeInsets.only(
                            top: a.width / 20,
                            left: a.width / 20,
                            bottom: a.width / 80),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.mail,
                              color: Colors.white,
                              size: a.width / 22,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'อีเมล',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                    Container(
                      width: a.width / 1.3,
                      height: a.width / 6.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(a.width)),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: a.width / 15,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'example@mail.com',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w900,
                            fontSize: a.width / 15,
                          ),
                        ),
                        validator: (val) {
                          return val.trim() == ""
                              ? 'กรุณากรอกข้อมูลให้ครบ'
                              : null;
                        },
                        onSaved: (val) {
                          _email = val.trim();
                        },
                      ),
                    ),
                    Container(
                      width: a.width,
                      padding: EdgeInsets.only(
                          top: a.width / 20,
                          left: a.width / 20,
                          bottom: a.width / 80),
                      child:
                          /*Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.white, fontSize: a.width / 20 , fontWeight: FontWeight.w600),
                        )*/
                          Row(
                        children: <Widget>[
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: a.width / 22,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            'รหัสผ่าน',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: a.width / 1.3,
                      height: a.width / 6.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(a.width)),
                      child: TextFormField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 10,
                          fontWeight: FontWeight.w900,
                          fontSize: a.width / 15,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '••••••••',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w900,
                            fontSize: a.width / 15,
                          ),
                        ),
                        validator: (val) {
                          return val.trim() == ""
                              ? 'กรุณากรอกข้อมูลให้ครบ'
                              : null;
                        },
                        onSaved: (val) {
                          _password = val.trim();
                        },
                      ),
                    ),
                    InkWell(
                        child: Container(
                            width: a.width / 1.3,
                            height: a.width / 6.5,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: a.width / 15, bottom: a.width / 35),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a.width / 40)),
                            child: Text("เข้าสู่ระบบ",
                                style: TextStyle(
                                  fontSize: a.width / 16,
                                  fontWeight: FontWeight.bold,
                                ))),
                        onTap: () async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            await login();
                          } else {
                            print('nope');
                          }
                        }),
                    InkWell(
                        child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: a.width / 20,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'เข้าสู่ระบบด้วยเบอร์โทร',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: a.width / 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPhone()));
                            })),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: a.width / 30),
              child: InkWell(
                child: Container(
                    width: a.width / 1.3,
                    height: a.width / 6.5,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: a.width / 22, bottom: a.width / 35),
                    decoration: BoxDecoration(
                        color: Color(0xff26A4FF),
                        borderRadius: BorderRadius.circular(a.width / 2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: a.width / 20,
                        ),
                        SizedBox(width: 5.0),
                        Text("สร้างบัญชี SCRAP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpMail()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
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

class LoginPhone extends StatefulWidget {
  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  String phone;
  var _key = GlobalKey<FormState>();

  Future<void> phoneVerified() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      print(id.toString() + " sent and " + resendCode.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(verifiedID: id, phone: phone)));
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      print('yes sure');
      // FirebaseUser user = await FirebaseAuth.instance.currentUser();
      // user.linkWithCredential(credent);
    };
    PhoneVerificationFailed failed = (AuthException error) {
      print(error);
    };
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: '+66' + phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> hasAccount(String phone) async {
    final QuerySnapshot phones = await Firestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = phones.documents;
    return doc.length == 1;
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(a.width / 20),
        child: Container(
          width: a.width,
          alignment: Alignment.topLeft,
          child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: a.width / 7,
                    height: a.width / 10,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white),
                        child: Icon(Icons.arrow_back,
                            color: Colors.black, size: a.width / 15),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
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
                          margin: EdgeInsets.only(
                              top: a.width / 20, bottom: a.width / 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(40.0),
                                      bottomLeft: const Radius.circular(40.0)),
                                  border: Border(
                                    top: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    left: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    right: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                width: a.width / 4,
                                height: a.width / 6.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '+66',
                                      style: TextStyle(
                                        fontSize: a.width / 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      child: Image.asset(
                                        'assets/thai-flag-round.png',
                                        width: a.width / 18,
                                        height: a.width / 18,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: a.width / 1.7,
                                height: a.width / 6.3,
                                padding: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topRight: const Radius.circular(40.0),
                                      bottomRight: const Radius.circular(40.0)),
                                  border: Border(
                                    top: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    left: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    right: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'เบอร์โทรศัพท์',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                  ),
                                  validator: (val) {
                                    return val.trim() == ""
                                        ? 'put isas'
                                        : val.trim().length > 10
                                            ? 'check 10 หลัก'
                                            : null;
                                  },
                                  onSaved: (val) {
                                    phone = val.trim();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "เราจะส่งเลข 6 หลัก เพื่อยืนยันเบอร์คุณ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: a.width / 18),
                        ),
                        SizedBox(
                          height: a.width / 7,
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a.width / 10)),
                            width: a.width / 2.5,
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: Text(
                              "ต่อไป",
                              style: TextStyle(
                                  fontSize: a.width / 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () async {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              await hasAccount(phone)
                                  ? await phoneVerified()
                                  : warning(
                                      context, 'ไม่พบัญชีที่ใช้เบอร์โทรนี้');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: a.width,
                    height: a.width / 10,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: Text(
                      'สร้างบัญชีใหม่',
                      style: TextStyle(
                          fontSize: a.width / 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500]),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "เกิดผิดพลาด",
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
