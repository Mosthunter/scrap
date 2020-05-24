import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';

class TestT extends StatefulWidget {
  @override
  _TestTState createState() => _TestTState();
}

class _TestTState extends State<TestT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Text('data'),
        ),
        onTap: (){
          authService.signOut(context);
        },
      ),
    );
  }
}