import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/OTPScreen.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class ChangePhone extends StatefulWidget {
  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  String phone;
  bool loading = false;
  var _key = GlobalKey<FormState>();

  Future<void> phoneVerified() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(
                    verifiedID: id,
                    phone: phone,
                    edit: true,
                  )));
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

  Future<bool> alreadyUse(String phone) async {
    final QuerySnapshot phones = await Firestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = phones.documents;
    return doc.length == 1;
  }

  changeNumber() async {
    final user = Provider.of<UserData>(context, listen: false);
    await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .updateData({'phone': phone});
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Padding(
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
                        height: a.height / 1.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "เปลี่ยนเบอร์โทรศัพท์",
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
                                          bottomLeft:
                                              const Radius.circular(40.0)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          bottomRight:
                                              const Radius.circular(40.0)),
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
                                            ? Taoast().toast("put isas")
                                            : val.trim().length > 10
                                                ? Taoast()
                                                    .toast("cheak 10 หลัก")
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
                                  setState(() {
                                    loading = true;
                                  });
                                  await alreadyUse(phone)
                                      ? warning(context,
                                          'เบอร์โทรนี้ได้ทำการลงทะเบียนไว้แล้ว')
                                      : await changeNumber();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  warning(BuildContext context, String sub) {
    setState(() {
      loading = false;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "เกิดข่้อผิดพลาด",
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
