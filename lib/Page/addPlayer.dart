import 'package:flutter/material.dart';
import 'package:scrap/widget/Arrow_back.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.black,
        child: Column(
          children: <Widget>[
            ArrowBack(),
            Container(
                padding:
                    EdgeInsets.only(left: a.width / 15, top: a.height / 300),
                width: a.width,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "ผู้คนรอบตัว",
                      style:
                          TextStyle(color: Colors.white, fontSize: a.width / 7),
                    ),
                    Text(
                        "พบกับระบบค้นหาผู้คนรอบตัวคุณ \nแล้วปาสแครปใส่พวกเขาได้ทันที เร็วๆนี้",
                        style: TextStyle(
                            color: Colors.white, fontSize: a.width / 20))
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: a.width / 8),
              width: a.width / 1.2,
              height: a.width / 1.2,
              child: Image.asset("assets/peoplescan.png"),
            )
          ],
        ),
      ),
    );
  }
}
