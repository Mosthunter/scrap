import 'package:flutter/material.dart';
import 'package:scrap/widget/ProfileCard.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: a.width,
        child: ListView(
          children: <Widget>[
            Container(
              // color: Colors.white,
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
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ), //back btn
                    SizedBox(
                      height: a.height / 12.5,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: a.width / 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "ค้นหาไอดี",
                            style: TextStyle(
                                fontSize: a.width / 8, color: Colors.white),
                          ),
                          Text("ค้นหาไอดีแล้วปาสแครปใส่พวกเขากัน",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 18)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: a.width / 10,
                        right: a.width / 25,
                        left: a.width / 25,
                      ),
                      height: a.width / 7.5,
                      width: a.width / 1.2,
                      decoration: BoxDecoration(
                          color: Color(0xff282828),
                          borderRadius: BorderRadius.circular(a.width)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: a.width / 25, right: a.width / 55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text("@natsatapon23",
                                  style: TextStyle(
                                    color: Color(0xff0094FF),
                                    fontSize: a.width / 16,
                                  )),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: a.width / 10.5,
                              height: a.width / 10.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(a.width),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                color: Color(0xff26A4FF),
                              ),
                              child: Icon(Icons.search,
                                  color: Colors.white, size: a.width / 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: a.width / 25,
                        left: a.width / 25,
                      ),
                      child: ProfileCard(),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: a.width / 17,
                        bottom: a.width / 17,
                        right: a.width / 25,
                        left: a.width / 25,
                      ),
                      width: a.width,
                      child: Row(
                        // ใส��� Row ��พื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: a.width / 20),
                            height: a.width / 5,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius:
                                    BorderRadius.circular(a.width / 20)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //color: Colors.black,
                                  width: a.width / 5,
                                  child: Column(
                                    //เพื่อใช้สำหรับให้ จำนวน และ เขียน
                                    children: <Widget>[
                                      Text(
                                        "เขียน",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 34),
                                      ),
                                      Text(
                                        "12",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: a.width / 5,
                                  // color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "ผู้คนหยิบอ่าน",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 34),
                                      ),
                                      Text(
                                        //เพื่อใช้สำหรับ��ห้ จำนวน และ ผ�����้หยิบอ่าน
                                        "41",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: a.width / 5,
                                  //  color: Colors.blue,
                                  child: Column(
                                    //เพื่อใช้สำหรับให้ จำนวน ��ละ โ��นปาใส��
                                    children: <Widget>[
                                      Text(
                                        "โดนปาใส่",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 34),
                                      ),
                                      Text(
                                        "9",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: a.width / 5,
                            height: a.width / 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(a.width),
                                border: Border.all(
                                    color: Colors.white24,
                                    width: a.width / 500)),
                            child: Container(
                              margin: EdgeInsets.all(a.width / 45),
                              width: a.width / 5,
                              height: a.width / 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(a.width),
                                  border: Border.all(color: Colors.white70)),
                              child: Container(
                                margin: EdgeInsets.all(a.width / 52),
                                width: a.width / 5,
                                height: a.width / 5,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white)),
                                child: Icon(
                                  Icons.create,
                                  size: a.width / 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
