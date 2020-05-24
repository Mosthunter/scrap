import 'package:flutter/material.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/widget/Toast.dart';

class CreatePaper extends StatefulWidget {
  @override
  _CreatePaperState createState() => _CreatePaperState();
}

class _CreatePaperState extends State<CreatePaper> {
  Scraps scraps = Scraps();
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width / 1.5,
      height: a.width / 4,
      color: Colors.grey,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(a.width / 40),
            width: a.width,
            height: a.width / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("เขียนโดย : " + "ใครสักคน"),
                    Text("เวลา : " + "11.11"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WriteScrap extends StatefulWidget {
  final String id;
  final String uid;
  final String tID;
  final String thrownUID;
  WriteScrap(
      {@required this.id,
      @required this.thrownUID,
      @required this.uid,
      @required this.tID});
  @override
  _WriteScrapState createState() => _WriteScrapState();
}

class _WriteScrapState extends State<WriteScrap> {
  DateTime now = DateTime.now();
  var _key = GlobalKey<FormState>();
  String text;
  bool public;
  Scraps scraps = Scraps();
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            InkWell(
              child: Container(
                child: Image.asset(
                  './assets/bg.png',
                  fit: BoxFit.cover,
                  width: a.width,
                  height: a.height,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Container(
              margin: EdgeInsets.only(
                  top: a.height / 8,
                  right: a.width / 20,
                  left: 20,
                  bottom: a.width / 8),
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: a.height,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: a.width / 13,
                                      height: a.width / 13,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              a.width / 50),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: Checkbox(
                                        value: public ?? false,
                                        onChanged: (bool value) {
                                          setState(() {
                                            public = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "\t" + "เปิดเผยตัวตน",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //ออกจาก��น้านี้
                              InkWell(
                                child: Icon(
                                  Icons.clear,
                                  size: a.width / 10,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        //ส่ว��ข���งกระดาษที่เขีย���
                        Container(
                          margin: EdgeInsets.only(top: a.width / 150),
                          width: a.width / 1,
                          height: a.height / 1.8,
                          //ทำเป���น�������ั้นๆ
                          child: Stack(
                            children: <Widget>[
                              //ช������้นที่ 1 ส่วนของก���ะดาษ
                              Container(
                                child: Image.asset(
                                  'assets/paper-readed.png',
                                  width: a.width / 1,
                                  height: a.height / 1.2,
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
                                    public ?? false
                                        ? Row(
                                            children: <Widget>[
                                              Text(
                                                "เขียนโดย : ",
                                                style: TextStyle(
                                                    fontSize: a.width / 22,
                                                    color: Colors.grey),
                                              ),
                                              Text("${widget.id}",
                                                  style: TextStyle(
                                                      fontSize: a.width / 22,
                                                      color: Color(0xff26A4FF)))
                                            ],
                                          )
                                        : Text(
                                            'เขียนโดย : ใครสักคน',
                                            style: TextStyle(
                                                fontSize: a.width / 22,
                                                color: Colors.grey),
                                          ),
                                    Text(
                                        now.minute < 10
                                            ? 'เวลา: ${now.hour}:0${now.minute}'
                                            : 'เวลา: ${now.hour}:${now.minute}',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: a.width / 22))
                                  ],
                                ),
                              ),
                              //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
                              Container(
                                width: a.width,
                                height: a.height,
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  width: a.width,
                                  child: TextFormField(
                                    textAlign: TextAlign
                                        .center, //เพื่อให้ข้อความอยู่ตรงกลาง
                                    style: TextStyle(fontSize: a.width / 14),
                                    maxLines: null,
                                    maxLength: 250,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border:
                                          InputBorder.none, //สำหรับใหเส้นใต้หาย
                                      hintText: 'เขียนข้อความบางอย่าง',
                                      hintStyle: TextStyle(
                                        height: 1.35,
                                        fontSize: a.width / 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    //หากไม่ได้กรอกจะขึ้น
                                    validator: (val) {
                                      return val.trim() == null ||
                                              val.trim() == ""
                                          ? Taoast()
                                              .toast("เขียนข้อความบางอย่างสิ")
                                          : null;
                                    },
                                    //เนื้อหาท��่กรอกเข้าไปใน text
                                    onChanged: (val) {
                                      text = val;
                                    },
                                  ),
                                ),
                              )
                              //)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: a.width / 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(left: a.width / 20),
                                  width: a.width / 4.5,
                                  height: a.width / 8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text("ปาเลย",
                                      style: TextStyle(
                                          fontSize: a.width / 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                onTap: () async {
                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();
                                    if (await scraps.blocked(
                                        widget.uid, widget.thrownUID)) {
                                      Navigator.pop(context);
                                      scraps.toast(
                                          'คุณไม่สามารถปาไปหา"${widget.tID}"ได้');
                                    } else {
                                      Navigator.pop(context);
                                      scraps.toast('ปาใส่"${widget.tID}"แล้ว');
                                      await scraps.throwTo(context,
                                          uid: widget.uid,
                                          writer: widget.id,
                                          thrownUID: widget.thrownUID,
                                          text: text);
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
