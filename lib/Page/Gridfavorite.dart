import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';
import 'dart:math' as math;

class Gridfavorite extends StatefulWidget {
  @override
  _GridfavoriteState createState() => _GridfavoriteState();
}

class _GridfavoriteState extends State<Gridfavorite> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: a.width,
              height: a.width / 5,
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: a.width / 20,
                    left: a.width / 30,
                    child: Container(
                      child: InkWell(
                        child: Container(
                            width: a.width / 15,
                            child: Image.asset(
                              "assets/Group 74.png",
                              //   fit: BoxFit.contain,
                              width: a.width / 12,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: a.width / 20,
                    left: a.width / 3.5,
                    child: Container(
                      child: Text(
                        'สแครปที่คุณติดตามในวันนี้',
                        style: TextStyle(
                            color: Colors.white, fontSize: a.width / 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            page == 0
                ? Container(
                    width: a.width,
                    height: a.height,
                    margin: EdgeInsets.only(top: a.width / 5),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Wrap(
                            spacing: a.width / 42,
                            runSpacing: a.width / 42,
                            alignment: WrapAlignment.center,
                            children: [
                              block('1'),
                              block('1'),
                              block('2'),
                              block('1'),
                              block('1'),
                              block('1'),
                            ]),
                        SizedBox(height: a.width / 5)
                      ],
                    ),
                  )
                : Container(
                    width: a.width,
                    height: a.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: a.width / 3,
                            height: a.width / 3,
                            child: Icon(
                              Icons.favorite,
                              size: a.width / 5,
                              color: Colors.grey,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff3C3C3C),
                                borderRadius: BorderRadius.circular(a.width)),
                          ),
                          SizedBox(
                            height: a.width / 20,
                          ),
                          text(
                            "คุณยังไม่ได้ติดสแครปในวันนี้",
                          ),
                          text(
                            "ลองกดหัวใจเพื่อการเคลื่อนไหว",
                          ),
                          text(
                            "ในสแครปที่ดูสนใจสิ",
                          )
                        ],
                      ),
                    )),
            Positioned(
              bottom: 0,
              child: AdmobBanner(
                  adUnitId: AdmobService().getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER),
            )
          ],
        ),
      ),
    );
  }

  Widget text(String textt) {
    Size a = MediaQuery.of(context).size;
    return Text(textt,
        style: TextStyle(
            color: Color(0xff3B3B3B),
            fontWeight: FontWeight.bold,
            fontSize: a.width / 15));
  }

  Widget block(String name) {
    Size a = MediaQuery.of(context).size;
    if (name == '1') {
      return GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: a.width / 2.2,
              height: (a.width / 2.1) * 1.21,
              color: Colors.white,
              child: Center(
                child: Text(
                  "datata",
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.all(a.width / 45),
                alignment: Alignment.center,
                width: a.width / 5.5,
                height: a.width / 11,
                decoration: BoxDecoration(
                    color: Color(0xfff707070),
                    borderRadius: BorderRadius.circular(a.width / 80)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "1.2K",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: a.width / 20),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(
                        Icons.sms,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Text(' '),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          // controller.refreshCompleted();
        },
      );
    } else {
      return GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: a.width / 2.2,
              height: (a.width / 2.1) * 1.21,
              color: Colors.white,
              child: Center(
                child: Text(
                  "Kuay",
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.all(a.width / 45),
                alignment: Alignment.center,
                width: a.width / 5.5,
                height: a.width / 11,
                decoration: BoxDecoration(
                    color: Color(0xfff0077CC),
                    borderRadius: BorderRadius.circular(a.width / 80)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "1.2K",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: a.width / 20),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(
                        Icons.sms,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Text(' '),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          // controller.refreshCompleted();
        },
      );
    }
  }
}
