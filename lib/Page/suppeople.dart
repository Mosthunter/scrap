import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/personcard.dart';
import 'package:scrap/Page/allfollower.dart';
import 'package:scrap/widget/personcard.dart';

TextEditingController checktext = TextEditingController();

class Subpeople extends StatefulWidget {
  @override
  _SubpeopleState createState() => _SubpeopleState();
}

class _SubpeopleState extends State<Subpeople> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: a.width,
          height: a.height,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: a.width / 1.7,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff262626)))),
                    padding: EdgeInsets.only(
                        top: a.width / 50,
                        left: a.width / 50,
                        right: a.width / 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: a.width,
                          height: a.width / 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Icon(Icons.arrow_back,
                                    color: Colors.white, size: a.width / 15),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "31" + " ผู้ติดตาม",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: a.width / 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: a.width / 15,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Text(
                          /* page == 0 */
                          checktext.text == null || checktext.text == ''
                              ? "\tค้นหาผู้คน"
                              : "\tติดตามผู้คน",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\tค้นหาผู้คนเพื่ออ่านสแครปหรือปาสแครปหาพวกเขา",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: a.width / 30,
                        ),
                        page == 0
                            ? InkWell(
                                /*onTap: () {
                                  setState(() {
                                    page = 1;
                                  });
                                },*/
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        //padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: a.width / 8,
                                        // width: screenWidthDp / 1.08,
                                        padding: EdgeInsets.only(
                                            left: a.width / 100,
                                            top: a.width / 500,
                                            right: a.width / 100,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          color: Color(0xff262626),
                                        ),
                                        child: TextField(
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 18),
                                          textAlign: TextAlign.center,
                                          controller: checktext,
                                          onChanged: (String string) {
                                            // page = 1;
                                            checktext.text = string.trim();
                                            checktext.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: checktext
                                                            .text.length));
                                            setState(() {
                                              //  page = 1;
                                            });
                                          },
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            // fillColor: Colors.red,
                                            hintText: '@someone',
                                            hintStyle: TextStyle(
                                                fontSize: a.width / 18,
                                                color: Colors.grey[600],
                                                height: a.width / 150),

                                            // labelText: 'Life story',
                                          ),
                                        ),
                                      ),
                                    ),
                                    /*   SizedBox(
                                      width: a.width / 10,
                                    ),*/
                                    checktext.text == '' ||
                                            checktext.text == null
                                        ? SizedBox()
                                        : GestureDetector(
                                            child: Text(
                                              '\t\tยกเลิก\t',
                                              style: TextStyle(
                                                  fontSize: a.width / 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              checktext.clear();
                                              // checktext.text = '';
                                              // page = 0;
                                              setState(() {
                                                //page = 0;
                                              });
                                            },
                                          ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: a.width / 1.3,
                                    height: a.width / 8,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff262626),
                                        borderRadius:
                                            BorderRadius.circular(a.width)),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          page = 0;
                                        });
                                      },
                                      child: Text(
                                        "ยกเลิก\t\t\t\t",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: a.width / 20),
                                      ))
                                ],
                              ),
                      ],
                    ),
                  ),
                  /*page == 0*/ checktext.text == null || checktext.text == ''
                      ? Container(
                          width: a.width,
                          height: a.height / 1.5,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Container(
                                width: a.width,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xff292929)))),
                                padding: EdgeInsets.only(
                                  left: a.width / 50,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: a.width / 25,
                                    ),
                                    Container(
                                      child: Text(
                                        "\tล่าสุดที่ปาใส่",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: a.width / 20,
                                    ),
                                    Wrap(
                                      children: <Widget>[
                                        Personcard(),
                                        Personcard(),
                                        Personcard(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: a.width / 30,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: a.width,
                                padding: EdgeInsets.only(
                                    //top: a.width / 20,
                                    left: a.width / 50,
                                    right: a.width / 50),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: a.width / 45,
                                    ),
                                    Container(
                                      width: a.width,
                                      height: a.width / 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "กำลังติดตาม " + "125",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: a.width / 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "ทั้งหมด",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: a.width / 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.white,
                                                  size: a.width / 15,
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Allfollower()),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: a.width / 20,
                                    ),
                                    Wrap(
                                      children: <Widget>[
                                        Personcard1(),
                                        Personcard1(),
                                        Personcard1(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: a.width / 7,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: a.width,
                          height: a.height / 1.5,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Container(
                                width: a.width,
                                padding: EdgeInsets.only(
                                    left: a.width / 50, right: a.width / 50),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: a.width / 25,
                                    ),
                                    Container(
                                      width: a.width,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "\tผู้คน",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: a.width / 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: a.width / 20,
                                    ),
                                    Wrap(
                                      children: <Widget>[
                                        Personcard1(),
                                        Personcard1(),
                                        Personcard1(),
                                        Personcard1(),
                                        Personcard1(),
                                        Personcard1(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: a.width / 7,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
              Positioned(
                bottom: 0,
                child: AdmobBanner(
                    adUnitId: AdmobService().getBannerAdId(),
                    adSize: AdmobBannerSize.FULL_BANNER),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
