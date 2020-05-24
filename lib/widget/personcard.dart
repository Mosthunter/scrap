import 'package:flutter/material.dart';
import 'package:scrap/widget/thrown.dart';

class Personcard extends StatefulWidget {
  @override
  _PersoncardState createState() => _PersoncardState();
}

class _PersoncardState extends State<Personcard> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width,
      height: a.width / 5,
      margin: EdgeInsets.only(bottom: a.width / 100, left: a.width / 100),
      child: Row(
        children: <Widget>[
          Container(
            width: a.width / 6,
            height: a.width / 6,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(a.width)),
          ),
          SizedBox(
            width: a.width / 30,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("@someone",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: a.width / 18,
                        fontWeight: FontWeight.bold)),
                Text("ต้นๆรถเป็นอะไรอ่ะ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: a.width / 22,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Personcard1 extends StatefulWidget {
  @override
  _Personcard1State createState() => _Personcard1State();
}

class _Personcard1State extends State<Personcard1> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width,
      height: a.width / 5,
      margin: EdgeInsets.only(bottom: a.width / 100, left: a.width / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: a.width / 6,
                height: a.width / 6,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(a.width)),
              ),
              SizedBox(
                width: a.width / 30,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("@someone",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: a.width / 18,
                            fontWeight: FontWeight.bold)),
                    Text("ต้นๆรถเป็นอะไรอ่ะ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: a.width / 22,
                        ))
                  ],
                ),
              )
            ],
          ),
          GestureDetector(
            child: Container(
              width: a.width / 6,
              height: a.width / 10,
              margin: EdgeInsets.only(top: a.width / 30, right: a.width / 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(a.width),
                  color: Colors.white),
              alignment: Alignment.center,
              child: Text(
                "ปาใส่",
                style: TextStyle(
                    color: Color(0xff26A4FF),
                    fontWeight: FontWeight.bold,
                    fontSize: a.width / 20),
              ),
            ),
            onTap: () {
              writerScrap(context);
            },
          ),
        ],
      ),
    );
  }
}
