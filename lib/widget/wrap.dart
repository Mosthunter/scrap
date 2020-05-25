import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/block.dart';

class Wrapblock extends StatefulWidget {
  @override
  _WrapblockState createState() => _WrapblockState();
}

class _WrapblockState extends State<Wrapblock> {
  Widget sizedbox() {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Container(
      height: 407 / 365 / 1.035 * s65 * s17,
      width: 365 / 407 / 1.035 * s65 * s17,
      color: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;

    return Container(
      child: Wrap(
        spacing: a.width / 42,
        runSpacing: a.width / 42,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Block(),
          Block(),
          Block(),
          Block(),
          Block(),
          Block(),
          Block(),
          sizedbox(),
        ],
      ),
    );
  }
}
