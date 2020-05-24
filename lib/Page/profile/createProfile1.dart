import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/createProfile2.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class CreateProfile1 extends StatefulWidget {
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();
  File image;
  StreamSubscription loadStatus;
  bool loading = false;

  @override
  void initState() {
    initID();
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  initID() {
    final user = Provider.of<UserData>(context, listen: false);
    id.text = user.id;
  }

  sendCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  sendPic() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  void dispose() {
    id.dispose();
    password.dispose();
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    screenutilInit(context);
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    height: scr.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: scr.width / 3,
                          ),
                          child: Text(
                            'สร้างไอดี',
                            style: TextStyle(
                              fontSize: scr.width / 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: appBarHeight / 3.5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    width: scr.width / 2.4,
                                    height: scr.width / 2.4,
                                    decoration: BoxDecoration(
                                      color: Color(0xff6A6A6A),
                                      borderRadius: BorderRadius.circular(
                                        scr.width / 3,
                                      ),
                                      border: Border.all(
                                          width: 3, color: Colors.white),
                                    ),
                                    child: ClipRRect(
                                        child: image == null
                                            ? SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.person,
                                                      size: scr.width / 5,
                                                      color: Color(0xfffffffff)
                                                          .withOpacity(0.37),
                                                    ),
                                                    Text(
                                                      'เพิ่มรูป',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: s42,
                                                        color: Color(
                                                                0xfffffffff)
                                                            .withOpacity(0.37),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Image.file(
                                                image,
                                                width: scr.width / 3,
                                                height: scr.width / 3,
                                                fit: BoxFit.cover,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          scr.width / 3,
                                        )),
                                  ),
                                  onTap: () {
                                    selectImg(context);
                                  },
                                ),
                                Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: scr.width / 16),
                                              width: scr.width / 1.5,
                                              height: scr.height / 15,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff272727),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: TextFormField(
                                                controller: id,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: s52,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: '@somename',
                                                  hintStyle: TextStyle(
                                                      fontSize: s52,
                                                      height: 1.2,
                                                      color: Color(0xffFFFFFF)
                                                          .withOpacity(0.15)),
                                                ),
                                                //ทำให้ตัวแรกของไอดีเป็น @
                                                onChanged: (gId) {
                                                  var trim = gId.trim();
                                                  trim[0] == '@'
                                                      ? id.text =
                                                          trim.substring(1)
                                                      : id.text = trim;
                                                  id.selection = TextSelection
                                                      .fromPosition(
                                                          TextPosition(
                                                              offset: id.text
                                                                  .length));
                                                },
                                                textInputAction:
                                                    TextInputAction.done,
                                              ),
                                            ),
                                            //pass
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: scr.width / 16),
                                              width: scr.width / 1.5,
                                              height: scr.height / 15,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff272727),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: TextFormField(
                                                controller: password,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: s52,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                obscureText: true,
                                                //autofocus: false,
                                                //obscureText: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'password',
                                                  hintStyle: TextStyle(
                                                      fontSize: s52,
                                                      height: 1.2,
                                                      color: Color(0xffFFFFFF)
                                                          .withOpacity(0.15)),
                                                ),
                                                onChanged: (val2) {
                                                  password.text = val2.trim();
                                                  password.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset: password
                                                                  .text
                                                                  .length));
                                                  setState(() {});
                                                },
                                                //ถ้าพาสเวิร์ด=='' || == null => toast
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? Taoast().toast(
                                                          "กรุณาใส่พาสเวิร์ดของท่าน")
                                                      : null;
                                                }),
                                                textInputAction:
                                                    TextInputAction.done,
                                              ),
                                            ),
                                            SizedBox(
                                              height: appBarHeight,
                                            ),
                                            next(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget next() {
    final user = Provider.of<UserData>(context, listen: false);
    Size scr = MediaQuery.of(context).size;
    if (password.text != '' && id.text != '' && image != null) {
      return Container(
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(appBarHeight / 7),
            width: scr.width / 1.5,
            height: scr.height / 15,
            decoration: BoxDecoration(
                color: Color(0xff26A4FE),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Text(
              'ต่อไป',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: s52,
                  fontWeight: FontWeight.w900,
                  color: Color(0xfffFFFFFF)),
            ),
          ),
          onTap: () async {
            authService.loading.add(true);
            if (password.text.length >= 6) {
              var docs =
                  (await authService.getDocuments('id', id.text)).documents;
              if (docs.length > 0 && docs[0].documentID != user.uid) {
                authService.warn('idนี้มีคนใช้แล้ว');
              } else {
                user.id = id.text;
                user.img = image;
                user.password = password.text;
                await fireStore
                    .collection('Account')
                    .document(user.uid)
                    .setData({'id': id.text}, merge: true);
                authService.loading.add(false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateProfile2()));
              }
            } else {
              authService.warn('รหัสผ่านต้องมี6ตัวขึ้นไป');
            }
          },
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(appBarHeight / 7),
        width: scr.width / 1.5,
        height: scr.height / 15,
        decoration: BoxDecoration(
            color: Color(0xff515151),
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Text(
          'ต่อไป',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: s52,
              fontWeight: FontWeight.w900,
              color: Color(0xfffFFFFFF).withOpacity(0.38)),
        ),
      );
    }
  }

  warning(String warn, {Function function}) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('ขออภัยค่ะ'),
            content: Container(
              child: Text(warn),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: function ??
                      () {
                        Navigator.pop(context);
                      },
                  child: Text('ok'))
            ],
          );
        });
  }

  selectImg(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: EdgeInsets.all(3),
        content: Container(
          height: scr.height / 3.8,
          width: scr.width / 1.1,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "อัปโหลดรูปภาพ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  iconImg(
                    Icons.image,
                    () {
                      sendPic();
                      Navigator.pop(context);
                    },
                  ),
                  iconImg(Icons.camera_alt, () {
                    sendCam();
                    Navigator.pop(context);
                  })
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ยกเลิก',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget iconImg(IconData icon, Function func) {
    Size scr = MediaQuery.of(context).size;
    return Container(
      width: scr.width / 1.1 / 2.8,
      height: scr.height / 6.4,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(18)),
      child: IconButton(
          icon: Icon(
            icon,
            size: scr.width / 6,
            color: Colors.grey[800],
          ),
          onPressed: func),
    );
  }
}
