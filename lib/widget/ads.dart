import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class Ads extends StatefulWidget {
  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: appBarHeight / 1.2,
            width: screenWidthDp,
            color: Colors.grey,
            child: Center(
              child: Text(
                'Google ADS',
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
