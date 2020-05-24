import 'package:flutter/material.dart';
import 'package:scrap/Page/GridFollowing.dart';
import 'package:scrap/Page/GridTopScrap.dart';
import 'dart:math' as math;

class Book_Widget extends StatelessWidget {
  //final String text;
  //Ads_Widget(this.text);
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: Container(
        /*  width: a.width / 2.5,
        height: a.width / 2,*/
        width: a.width / 400 * 174,
        height: a.width / 400 * 211,
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),

        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/564x/4d/99/81/4d99817fb9a9b2871af902218eb77261.jpg'), //firebase
            fit: BoxFit.cover,
          ),
          //  borderRadius: BorderRadius.circular(3),
          //color: Colors.yellow.shade700,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              offset: Offset(-1.5, 1.5),
              blurRadius: 3,
            )
          ],
        ),

        //color: Colors.yellow.shade700,
        //child: Center(child: Text(text)),
      ),
    );
  }
}

class Ads_Widget extends StatelessWidget {
  //final String text;
  //Ads_Widget(this.text);
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: Container(
        // width: 120,
        height: 150,
        /* margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),*/

        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://www.mktsme.com/wp-content/uploads/2018/12/Facebook-Ads-768x399.jpg'), //firebase
            fit: BoxFit.cover,
          ),
          // borderRadius: BorderRadius.circular(3),
          //color: Colors.yellow.shade700,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              offset: Offset(-1.5, 1.5),
              blurRadius: 3,
            )
          ],
        ),

        //color: Colors.yellow.shade700,
        //child: Center(child: Text(text)),
      ),
    );
  }
}

class Gridsubscripe extends StatefulWidget {
  @override
  _GridsubscripeState createState() => _GridsubscripeState();
}

class _GridsubscripeState extends State<Gridsubscripe> {
  int page = 0;
  var controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget block() {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            height: 407 / a.width * 150,
            width: 365 / a.width * 150,
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
  }

  Widget following() {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Wrap(
              spacing: a.width / 42,
              runSpacing: a.width / 42,
              alignment: WrapAlignment.center,
              children: [
                block(),
                block(),
                block(),
                block(),
                block(),
                block(),
                block(),
                block(),
                Ads_Widget(),
                block(),
                block(),
                block(),
                block(),
                block(),
                block(),
                block(),
                block(),
                Ads_Widget(),
              ]),
          //  SizedBox(height: a.width / 5)
        ],
      ),
    );
  }

  Widget interest() {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Wrap(
            spacing: a.width / 42,
            runSpacing: a.width / 42,
            alignment: WrapAlignment.center,
            children: [
              //Container(height: screenHeightDp/10,),
              block(),
              Ads_Widget(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: a.width,
              height: a.width / 5,
              padding: EdgeInsets.only(
                  top: a.width / 50, left: a.width / 30, right: a.width / 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                        width: a.width / 18,
                        child: Image.asset(
                          "assets/Group 74.png",
                          fit: BoxFit.contain,
                          /*  width: a.width / 10,
                          height: a.width / 10,*/
                        )),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Text(
                          "จากผู้คนที่ติดตาม",
                          style: page != 0
                              ? TextStyle(
                                  color: Colors.white, fontSize: a.width / 20)
                              : TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                        onTap: () {
                          if (controller.page != 0)
                            controller.previousPage(
                                duration: Duration(milliseconds: 120),
                                curve: Curves.ease);
                        },
                      ),
                      Text(
                        " | ",
                        style: TextStyle(
                            color: Colors.white, fontSize: a.width / 20),
                      ),
                      InkWell(
                        child: Text(
                          "สแครปน่าติดตาม",
                          style: page != 1
                              ? TextStyle(
                                  color: Colors.white, fontSize: a.width / 20)
                              : TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          if (controller.page != 1)
                            controller.nextPage(
                                duration: Duration(milliseconds: 120),
                                curve: Curves.ease);
                        },
                      ),
                    ],
                  ),
                  Icon(Icons.history, color: Colors.white, size: a.width / 13)
                ],
              ),
            ),
            Container(
                width: a.width,
                height: a.height,
                padding: EdgeInsets.only(top: a.width / 5),
                child: PageView(
                  onPageChanged: (index) {
                    setState(() => page = index);
                  },
                  controller: controller,
                  children: <Widget>[following(), interest()],
                ))
          ],
        ),
      ),
    );
  }
}
