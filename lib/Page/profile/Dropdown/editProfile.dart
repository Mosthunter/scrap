import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/profile/Dropdown/ChangePhone.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class EditProfile extends StatefulWidget {
  final DocumentSnapshot doc;
  final DocumentSnapshot info;
  final String email;
  final String password;
  final String id;
  EditProfile(
      {@required this.doc,
      @required this.info,
      @required this.id,
      @required this.email,
      @required this.password});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _key = GlobalKey<FormState>();
  bool loading = false;
  var _email = TextEditingController();
  var _password = TextEditingController();
  var txID = TextEditingController();
  File image;
  String id;
  Map account = {};

  summitNewID(String uid) async {
    widget.id[0] == id[0] ? await addUnchangeID(uid) : await addChangeID(uid);
  }

  addUnchangeID(String uid) async {
    await Firestore.instance
        .collection('SearchUsers')
        .document(id[0])
        .collection('users')
        .document(uid)
        .updateData({'id': id});
    await Firestore.instance.collection('Users').document(uid).updateData({
      'id': id,
    });
  }

  addChangeID(String uid) async {
    await Firestore.instance
        .collection('SearchUsers')
        .document(widget.id[0])
        .collection('users')
        .document(uid)
        .delete();
    await Firestore.instance
        .collection('SearchUsers')
        .document(id[0])
        .collection('users')
        .document(uid)
        .setData({
      'id': id,
      'uid': uid,
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': id});
  }

  sendCam() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  sendPic() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Future cimg(File img, String uid, String imgNm) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(imgNm);
    final StorageUploadTask task = ref.putFile(img);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    await addImg(uid, picUrl);
    await userinfo.editProImage(picUrl);
    if (task.isInProgress) {
      setState(() {
        loading = true;
      });
    } else {
      print('complet');
    }
  }

  addImg(String uid, String pic) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .updateData({
      'img': pic,
    });
  }

  newAccount() async {
    var user = await FirebaseAuth.instance.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(
        email: user.email, password: widget.password);
    if (user.email != account['email']) {
      user.reauthenticateWithCredential(credential).then((auth) async {
        user.updateEmail(account['email']);
        await updateAccount('email', account['email']);
      });
    }
    if (widget.password != account['password']) {
      user.reauthenticateWithCredential(credential).then((auth) async {
        user.updatePassword(account['password']);
        await updateAccount('password', account['password']);
      });
    }
  }

  Future<bool> hasAccount(String user) async {
    final QuerySnapshot users = await Firestore.instance
        .collection('Users')
        .where('id', isEqualTo: user)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = users.documents;
    return doc.length == 1;
  }

  updateAccount(String key, String value) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .updateData({key: value});
  }

  saveEdit() async {
    try {
      setState(() {
        loading = true;
      });
      if (id != widget.id) {
        await summitNewID(widget.doc['uid']);
      }
      if (image != null) {
        await cimg(image, widget.doc['uid'], widget.doc['uid'] + '_pro');
      }
      await newAccount();
      setState(() {
        loading = false;
      });
      Taoast().toast('แก้ไขข้อมูลเสร็จสิ้น');
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      warning('เกิดข้อผิดพลาดกรุราลองใหม่');
    }
  }

  @override
  void initState() {
    txID.text = '@' + widget.id;
    _email.text = widget.email;
    _password.text = widget.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ListView(children: <Widget>[
            Form(
              key: _key,
              child: Container(
                color: Colors.black,
                width: a.width,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: a.width / 20,
                      right: a.width / 25,
                      left: a.width / 25,
                      bottom: a.width / 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            //back btn
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
                              Navigator.pop(
                                context,
                              );
                            },
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                if (id != widget.id) {
                                  await hasAccount(id)
                                      ? warning(
                                          'ไอดีนี้ได้ทำการลงทะเบียนไว้แล้ว')
                                      : saveEdit();
                                } else {
                                  saveEdit();
                                }
                              }
                            },
                            icon: Icon(
                              Icons.save,
                              color: Colors.black,
                              size: a.width / 20,
                            ),
                            label: Text(
                              "บันทึก",
                              style: TextStyle(
                                  color: Colors.black, fontSize: a.width / 16),
                            ),
                          ),
                        ],
                      ), //back btn

                      SizedBox(height: a.height / 10.5),

                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'แก้ไขบัญชี',
                          style: TextStyle(
                              fontSize: a.width / 6.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: a.height / 4.5,
                              width: a.width,
                              decoration: BoxDecoration(
                                  color: Color(0xff282828),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: a.width / 20,
                                            right: a.width / 33),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(a.width),
                                            border: Border.all(
                                                color: Colors.white,
                                                width: a.width / 190)),
                                        width: a.width / 3.3,
                                        height: a.width / 3.3,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(a.width),
                                            child: image == null
                                                ? Image.network(
                                                    widget.info['img'],
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  )),
                                      ),
                                      onTap: () {
                                        selectImg(context);
                                      },
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        inputID(a),
                                        Text(
                                          widget.info['createdDay']
                                                      .runtimeType ==
                                                  String
                                              ? "Join ${widget.info['createdDay']}"
                                              : "Join ${DateFormat('d/M/y').format(widget.info['createdDay'].toDate())}",
                                          style: TextStyle(
                                              fontSize: a.width / 11,
                                              color: Color(0xff26A4FF)),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            Positioned(
                              right: 10.0,
                              top: 10.0,
                              child: Icon(
                                (Icons.create),
                                color: Colors.white,
                                size: a.width / 13,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: a.height / 2.3,
                              width: a.width,
                              color: Color(0xff282828),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.mail,
                                          color: Colors.white,
                                          size: a.width / 13,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'อีเมล',
                                          style: TextStyle(
                                              fontSize: a.width / 13,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    editAccount(_email, false, a, 'email',
                                        'name@mail.com',
                                        validator: (val) => val.trim() == ""
                                            ? Taoast().toast("put Address")
                                            : val.contains('@') &&
                                                    val.contains(
                                                        '.com', val.length - 4)
                                                ? null
                                                : Taoast().toast(
                                                    "กรุณาตรวจสอบอีเมลของท่าน")),
                                    SizedBox(height: a.height / 30),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: a.width / 13,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'รหัสผ่าน',
                                          style: TextStyle(
                                              fontSize: a.width / 13,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    editAccount(_password, true, a, 'password',
                                        '••••••••',
                                        validator: (val) => val.trim() == ""
                                            ? Taoast()
                                                .toast("กรุณากรอกข้อมูลให้ครบ")
                                            : val.trim().length < 6
                                                ? Taoast().toast(
                                                    "รหัสต้องมีอย่างน้อย 6 ตัว")
                                                : null)
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10.0,
                              top: 10.0,
                              child: Icon(
                                (Icons.create),
                                color: Colors.white,
                                size: a.width / 13,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: a.height / 4.5,
                          width: a.width,
                          decoration: BoxDecoration(
                              color: Color(0xff282828),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'เบอร์โทรศัพท์',
                                style: TextStyle(
                                    fontSize: a.width / 17,
                                    color: Color(0xff5F5F5F)),
                              ),
                              Text(
                                widget.doc['phone'] == ''
                                    ? 'ไม่มี'
                                    : "${widget.doc['phone'].substring(0, 3)}-${widget.doc['phone'].substring(3, 6)}-${widget.doc['phone'].substring(6, 10)}",
                                style: TextStyle(
                                    fontSize: a.width / 12,
                                    color: Color(0xff5F5F5F)),
                              ),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: a.width / 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'เปลี่ยนเบอร์โทรศัพท์',
                                      style: TextStyle(
                                          fontSize: a.width / 18,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChangePhone()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  Widget inputID(Size a) {
    return Container(
      width: a.width / 2,
      height: a.height / 21,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: txID,
        style: TextStyle(fontSize: a.width / 13, color: Colors.white),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'ใส่@ของคุณ'),
        validator: (val) {
          return val.trim() == "" ? Taoast().toast("กรุณากรอกข้อความ") : null;
        },
        onSaved: (val) {
          val.trim()[0] == '@' ? id = val.trim().substring(1) : id = val.trim();
        },
      ),
    );
  }

  warning(String warn, {Function function}) {
    setState(() {
      loading = false;
    });
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

  Widget editAccount(
      TextEditingController tx, bool pass, Size a, String type, String hint,
      {String validator(String val)}) {
    return Container(
      margin: EdgeInsets.only(top: a.width / 30),
      padding: EdgeInsets.only(left: 15),
      width: a.width,
      height: a.height / 11.5,
      decoration: BoxDecoration(
        color: Color(0xff363636),
        borderRadius: BorderRadius.only(
            topRight: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
            topLeft: const Radius.circular(10.0),
            bottomLeft: const Radius.circular(10.0)),
      ),
      child: TextFormField(
        obscureText: pass,
        controller: tx,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontSize: a.width / 13,
          fontWeight: FontWeight.w900,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700]),
        ),
        validator: validator,
        onSaved: (gId) => account[type] = gId.trim(),
        textInputAction: TextInputAction.done,
      ),
    );
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
