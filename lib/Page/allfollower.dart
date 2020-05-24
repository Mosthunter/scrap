import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/personcard.dart';

class Allfollower extends StatefulWidget {
  @override
  _AllfollowerState createState() => _AllfollowerState();
}

class _AllfollowerState extends State<Allfollower> {
  Widget appbar() {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width,
      height: a.width / 5,
      //color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          Text(
            'ผู้ติดตาม',
            style: TextStyle(
                color: Colors.white,
                fontSize: a.width / 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: a.width / 7.5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: a.height,
        width: a.width,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                child: Container(
                  child: appbar(),
                )),
            Positioned(
              top: a.width / 5,
              child: Container(
                height: a.height,
                width: a.width,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    Personcard1(),
                    SizedBox(
                      height: a.width / 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
