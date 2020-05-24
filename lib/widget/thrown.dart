import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/SelectPosition.dart';
import 'package:scrap/widget/Ads.dart';

//ฟังก์ชั่นปากระดาษ
void writerScrap(BuildContext context, {LatLng latLng, bool isThrow = false}) {
  var _key = GlobalKey<FormState>();
  bool public = false;
  final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
  showDialog(
      context: context,
      builder: (context) {
        Size a = MediaQuery.of(context).size;
        screenutilInit(context);
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      width: a.width,
                      height: a.height,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                Container(
                  width: a.width,
                  margin: EdgeInsets.only(
                      top: a.height / 8,
                      right: a.width / 60,
                      left: a.width / 40,
                      bottom: a.width / 8),
                  child: ListView(
                    children: <Widget>[
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: a.height,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: a.width / 13,
                                          height: a.width / 13,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: Colors.transparent)),
                                          child: Checkbox(
                                            tristate: false,
                                            activeColor: Color(0xfff707070),
                                            value: public,
                                            onChanged: (bool value) {
                                              public = value;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "\t" + "ไม่ระบุตัวตน",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: a.width / 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //ออกจากหน้าปากระดาษ
                                  /*  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xfff707070),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Icon(
                                        Icons.clear,
                                        size: a.width / 15,
                                        //color: Color(0xfff707070),
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),*/
                                ],
                              ),
                            ),
                            //กระดาษที่ไว้เขียนไงจ้ะ
                            Container(
                              margin: EdgeInsets.only(top: a.width / 150),
                              width: a.width / 1,
                              height: a.height / 1.8,
                              //ใช้สแต็กเอา
                              child: Stack(
                                children: <Widget>[
                                  //รูปกระดาษ
                                  Center(
                                    child: Container(
                                      child: Image.asset(
                                        'assets/paper-readed.png',
                                        width: a.width / 1.04,
                                        height: a.width / 1.04 * 1.115,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                      child: Container(
                                    //color: Colors.red,
                                    width: a.width,
                                    height: a.height,
                                    alignment: Alignment.center,
                                    child: Container(
                                      // color: Colors.red,
                                      padding: EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                      ),
                                      // width: a.width,
                                      child: Form(
                                        key: _key,
                                        child: TextFormField(
                                          maxLength: 250,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1.35,
                                              fontSize: a.width / 14),
                                          maxLines: null,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            counterStyle: TextStyle(
                                                color: Colors.transparent),
                                            border: InputBorder
                                                .none, //สำหรับให้เส้นใต้หาย
                                            hintText:
                                                'เขียนบางอย่างที่คุณอยากบอก',
                                            hintStyle: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (val) {
                                            return val.trim() == ""
                                                ? scrap.toast(
                                                    "ลองเขียนข้อความบางอย่างสิ")
                                                : null;
                                          },
                                          onSaved: (val) {
                                            scrapData.text = val.trim();
                                          },
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenWidthDp / 21),
                                  child: GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xfff333333),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: a.width / 4.2,
                                        height: a.width / 8,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'ยกเลิก',
                                          style: TextStyle(
                                              color: Color(0xfffD8D8D8),
                                              fontSize: a.width / 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                                SizedBox(
                                  width: appBarHeight / 2.8,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenWidthDp / 21),
                                  child: GestureDetector(
                                      child: Container(
                                        width: a.width / 4.2,
                                        height: a.width / 8,
                                        decoration: BoxDecoration(
                                            color: isThrow
                                                ? Colors.white
                                                : Color(0xff26A4FF),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        alignment: Alignment.center,
                                        child: Text(
                                            isThrow ? "ปาใส่" : 'โยนไว้',
                                            style: TextStyle(
                                                color: isThrow
                                                    ? Color(0xff26A4FF)
                                                    : Colors.white,
                                                fontSize: a.width / 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      onTap: () {
                                        if (_key.currentState.validate()) {
                                          _key.currentState.save();
                                          scrapData.public = public;
                                          if (!isThrow) {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectPosition(
                                                            defaultLatLng:
                                                                latLng)));
                                          }
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // แปะโฆษณา
                Positioned(
                    bottom: 0,
                    child: Container(
                      child: Ads(),
                    )),
              ],
            ),
          );
        });
      });
}

class Throwpaper extends StatefulWidget {
  @override
  _ThrowpaperState createState() => _ThrowpaperState();
}

class _ThrowpaperState extends State<Throwpaper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: GestureDetector(
          child: Text('Throw'),
          onTap: () {
            writerScrap(context, isThrow: true);
          },
        ),
      )),
    );
  }
}
