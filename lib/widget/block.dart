import 'package:flutter/material.dart';

class Block extends StatefulWidget {
  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      height: 407 / a.width * 165,
      width: 365 / a.width * 165,
      color: Colors.red,
    );
  }
}
