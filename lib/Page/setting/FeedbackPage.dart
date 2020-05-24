import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/warning.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String text;
  File image;
  bool loading = false;
  var _key = GlobalKey<FormState>();

  Future addData(File img, String refer) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(refer);
    final StorageUploadTask task = ref.putFile(img);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    await Firestore.instance
        .collection('Report')
        .document(refer)
        .updateData({'img': picUrl});
    if (task.isInProgress) {
      setState(() {
        loading = true;
      });
    } else {
      print('complet');
    }
  }

  describeApp() async {
    DateTime now = DateTime.now();
    String date = DateFormat('y,M,d').format(now);
    final user = Provider.of<UserData>(context, listen: false);
    try {
      setState(() {
        loading = true;
      });
      await Firestore.instance
          .collection('App')
          .document('feedBack')
          .collection(date)
          .add({'text': text, 'time': now, 'uid': user.uid}).then((value) =>
              image != null ? addData(image, value.documentID) : null);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        loading = false;
      });
      Dg().warning(context, 'เกิดข้อผิดพลาด กรุณาลองใหม่', "เกิดผิดพลาด");
    }
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

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Form(
            key: _key,
            child: ListView(children: <Widget>[
              Container(
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
                        ],
                      ), //back btn

                      SizedBox(height: a.height / 10.5),

                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'ให้คำแนะนำแก่เรา',
                          style: TextStyle(
                              fontSize: a.width / 6.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'หากคุณมีไอเดียดีๆที่อยากเพิ่มฟังก์ชันการใช้งานหรือความกวนใจขณะใช้งานแอปพลิเคชัน\n“ ปาสแครปใส่เราสิ! ”',
                          style: TextStyle(
                              fontSize: a.width / 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        margin: EdgeInsets.only(top: a.width / 50),
                        width: a.width / 1,
                        height: a.height / 1.8,
                        //ทำเป็นชั้นๆ
                        child: Stack(
                          children: <Widget>[
                            //ช���้นที่ 1 ส่วนของก���ะดาษ
                            Container(
                              child: Image.asset(
                                'assets/paper-readed.png',
                                width: a.width / 1,
                                height: a.height / 1.8,
                                fit: BoxFit.cover,
                              ),
                            ),
                            //ชั้นที่ 2
                            Container(
                              margin: EdgeInsets.only(
                                  left: a.width / 20, top: a.width / 20),
                              width: a.width,
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'เขียนถึง : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: '@scrapteam',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                  // Text("เว��า" + " : " + time,
                                  //     style:
                                  //         TextStyle(color: Colors.grey))
                                ],
                              ),
                            ),
                            //ชั้��ที่ 3 เอาไว้สำหรับเขียนข้อความ
                            Container(
                              width: a.width,
                              height: a.height,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: a.width / 1.5,
                                child: TextFormField(
                                  textAlign: TextAlign
                                      .center, //เพื่อให้ข้อความอยู่ตรงกลาง
                                  style: TextStyle(fontSize: a.width / 15),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border:
                                        InputBorder.none, //สำหรับใหเส้นใต้หาย
                                    hintText: 'เขียนข้อความบางอย่าง',
                                    hintStyle: TextStyle(
                                      fontSize: a.width / 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  //หากไม่ได้กรอกจะขึ้น
                                  validator: (val) {
                                    return val.trim() == null ||
                                            val.trim() == ""
                                        ? 'เขียนบางอย่างสิ'
                                        : null;
                                  },
                                  //เนื้อหาที่��รอกเข้าไปใน text
                                  onSaved: (val) {
                                    text = val;
                                  },
                                ),
                              ),
                            )
                            //)
                          ],
                        ),
                      ),

                      SizedBox(height: a.height / 30),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              child: image == null
                                  ? Container(
                                      height: a.height / 9,
                                      width: a.width,
                                      decoration: BoxDecoration(
                                          color: Color(0xff282828),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.image,
                                                size: a.width / 13,
                                                color: Color(0xff26A4FF)),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'แตะเพื่อแนบภาพ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Color(0xff26A4FF)),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      children: <Widget>[
                                        Container(
                                          height: a.height / 4,
                                          width: a.width,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      a.width)),
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.clear,
                                                size: a.width / 12,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  image = null;
                                                });
                                              }),
                                        )
                                      ],
                                    ),
                              onTap: () {
                                selectImg(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: a.height / 40),
                      Center(
                        child: InkWell(
                          child: Container(
                            width: a.width / 4.0,
                            height: a.width / 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(a.width)),
                            alignment: Alignment.center,
                            child: Text("ปาเลย",
                                style: TextStyle(
                                    fontSize: a.width / 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900)),
                          ),
                          onTap: () async {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              await describeApp();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
          loading ? Loading() : SizedBox()
        ],
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
