import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateProfile extends StatefulWidget {
  final String uid;
  CreateProfile({@required this.uid});
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  var _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String date, genders, name, created, lname, selectYear, id;
  File image;
  bool loading = false;

  @override
  void initState() {
    date = DateFormat('d/M/y').format(selectedDate);
    created = DateFormat('d/M/y').format(selectedDate);
    selectYear = DateFormat('y').format(selectedDate);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1990, 1, 1),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(int.parse(selectYear), 1));
    if (picked != null && picked != selectedDate)
      setState(() {
        date = DateFormat('d/M/y').format(picked);
      });
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

  Future cimg(File img, String uuid, String imgNm) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(imgNm);
    final StorageUploadTask task = ref.putFile(img);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    await addImg(uuid, picUrl);
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

  addData(String uid) async {
    List index = [];
    for (int i = 0; i <= id.length; i++) {
      index.add(i == 0 ? id[0] : id.substring(0, i));
    }
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .setData({
      'name': name + ' ' + lname,
      'birthDay': date,
      'genders': genders,
      'createdDay': created
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': id, 'searchIndex': index});
  }

  creatProfile() async {
    try {
      image == null
          ? print('nope')
          : await cimg(image, widget.uid, widget.uid + '_pro');
      await addData(widget.uid);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: scr.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            scr.width / 13.5, 0, scr.width / 13.5, 0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Text('กรอกข้อมูล'),
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 15),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: <Widget>[
                                //       Text(
                                //         'สร้างบัญชี',
                                //         style: TextStyle(
                                //           color: Colors.grey[800],
                                //           fontSize: 25,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                InkWell(
                                  child: Container(
                                    width: scr.width / 3,
                                    height: scr.width / 3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(
                                          scr.width / 3,
                                        )),
                                    child: ClipRRect(
                                        child: image == null
                                            ? SizedBox(
                                                child: Icon(
                                                  Icons.edit,
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
                                  // padding: EdgeInsets.all(16),
                                  // color: Colors.grey[300],
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Column(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.stretch,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              width: scr.width,
                                              height: scr.height / 12,
                                              child: TextFormField(
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? 'กรุณากรอก@ของคุณ'
                                                      : null;
                                                }),
                                                onSaved: (lnam) =>
                                                    id = lnam.trim(),
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    prefixText: '@',
                                                    helperText:
                                                        'ทุกคนสามารถเห็น"ชื่อ"ของคุณและปากระดาษหาคุณได้',
                                                    hintText: ' ใส่ชื่อของคุณ'),
                                              ),
                                            ),
                                            Container(
                                              width: scr.width,
                                              height: scr.height / 12,
                                              child: TextFormField(
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? 'กรุณากรอกชื่อของท่าน'
                                                      : null;
                                                }),
                                                onSaved: (nam) =>
                                                    name = nam.trim(),
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    hintText: 'ชื่อจริง'),
                                              ),
                                            ),
                                            Container(
                                              width: scr.width,
                                              height: scr.height / 12,
                                              child: TextFormField(
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? 'กรุณากรอกนามสกุลของท่าน'
                                                      : null;
                                                }),
                                                onSaved: (lnam) =>
                                                    lname = lnam.trim(),
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    hintText: 'นามสกุล'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('วันเกิด'),
                                            IconButton(
                                              icon: Icon(Icons.date_range),
                                              color: Color(0xffEF7D36),
                                              onPressed: () =>
                                                  _selectDate(context),
                                            ),
                                            Text(date)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('เพศของคุณ'),
                                            Radio(
                                              onChanged: (String ty) {
                                                setState(() => genders = ty);
                                              },
                                              value: 'ชาย',
                                              groupValue: genders,
                                              activeColor: Color(0xffEF7D36),
                                            ),
                                            Text('ชาย'),
                                            Radio(
                                              onChanged: (String ty) {
                                                setState(() => genders = ty);
                                              },
                                              value: 'หญิง',
                                              groupValue: genders,
                                              activeColor: Color(0xffEF7D36),
                                            ),
                                            Text('หญิง'),
                                            Radio(
                                              onChanged: (String ty) {
                                                setState(() => genders = ty);
                                              },
                                              value: '',
                                              groupValue: genders,
                                              activeColor: Color(0xffEF7D36),
                                            ),
                                            Text('อื่นๆ'),
                                            genders == ''
                                                ? Expanded(
                                                    child: TextFormField(
                                                      validator: ((val) {
                                                        return val.trim() == ''
                                                            ? 'กรุณาระบุเพศ'
                                                            : null;
                                                      }),
                                                      onSaved: (gen) =>
                                                          genders = gen.trim(),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  '   ระบุ'),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: scr.height / 10),
                                          child: MaterialButton(
                                            child: Text(
                                              'สร้างบัญชี',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            onPressed: () async {
                                              _formKey.currentState.save();
                                              if (_formKey.currentState
                                                      .validate() &&
                                                  genders != null &&
                                                  date != created) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                await creatProfile();
                                              } else {
                                                date == created
                                                    ? warnDate()
                                                    : print('nope');
                                              }
                                            },
                                            color: Color(0xffEF7D36),
                                            elevation: 0,
                                            minWidth: 350,
                                            height: 60,
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox()
        ],
      ),
    );
  }

  warnDate() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('กรุณาเลือกวันเกิดของท่าน'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
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
