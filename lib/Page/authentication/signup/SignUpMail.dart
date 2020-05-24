import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/authentication/signup/SignUpTel.dart';
import 'package:scrap/Page/setting/servicedoc.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/warning.dart';

class SignUpMail extends StatefulWidget {
  SignUpMail({Key key}) : super(key: key);
  @override
  _SignUpMailState createState() => _SignUpMailState();
}

class _SignUpMailState extends State<SignUpMail> {
  String _email, _password;
  bool loading = false;
  var _key = GlobalKey<FormState>();

  Future<bool> uniqueEmail(String email) async {
    final QuerySnapshot emails = await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = emails.documents;
    return doc.length < 1;
  }

  continueSignUp() {
    setState(() {
      loading = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpTel(
                  email: _email,
                  password: _password,
                )));
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: a.width / 20),
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: a.width / 10),
                          child: Text(
                            "สมัครสมาชิก",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 9,
                                fontFamily: 'ThaiSans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            '"ผู้คนกำลังรออ่านสแครปของคุณ"',
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
                                borderRadius:
                                    BorderRadius.circular(a.width / 20)),
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
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
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
                                          ? Taoast().toast("กรุณากรอกรหัสผ่าน")
                                          : val.contains('@') &&
                                                  val.contains(
                                                      '.com', val.length - 4)
                                              ? null
                                              : Taoast().toast(
                                                  "โปรดเขียนอีเมลให้ถูกต้อง");
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
                                  child: Row(
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
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
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
                                          ? Taoast().toast("กรุณากรอกรหัสผ่าน")
                                          : val.trim().length < 6
                                              ? Taoast().toast(
                                                  "รหัสต้องมีอย่างน้อย 6 ตัว")
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
                                            top: a.width / 15,
                                            bottom: a.width / 35),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                a.width / 40)),
                                        child: Text("ดำเนินการต่อ",
                                            style: TextStyle(
                                              fontSize: a.width / 16,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                    onTap: () async {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        setState(() {
                                          loading = true;
                                        });
                                        await uniqueEmail(_email)
                                            ? continueSignUp()
                                            : fail();
                                      } else {
                                        print('nope');
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: a.height / 56,
                        ),
                        SizedBox(
                          width: a.width / 1.2,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              Text(
                                'การกดดำเนินการต่อจะหมายถึงการที่คุณยอมรับใน',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Servicedoc()));
                                },
                                child: Text(
                                  '"ข้อกำหนด" ',
                                  style: TextStyle(
                                      color: Color(0xff26A4FF),
                                      fontSize: a.width / 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                'ทั้งหมดของเรา',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ]));
  }

  fail() {
    setState(() {
      loading = false;
    });
    Dg().warning(context, 'ขออภัยอีเมลนี้ได้ลงทะเบียนไว้แล้ว', "เกิดผิดพลาด");
  }
}
