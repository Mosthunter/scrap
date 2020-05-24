import 'dart:io';
import 'dart:ui';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/widget/wrap.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/OptionSetting_My_Profile.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
/* 
List Problem ( control+F => showPopup(context) / wrap() )
- void showPopup(context) -> TextField : ขยายขนาดไม่ได้
- wrap() : ต้องเปลี่ยนเป็น "ตารางสแครปยอดนิยมและจากคนที่เราติดตาม" ตามใน XD
*/

//หน้าโปรไฟล์ของฉัน
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isSwitched = false, initInfoFinish = false;
  Map profile = {};
  int page = 0;
  var controller = PageController();

  //Appbar สำหรับหน้าโปรไฟล์ของฉัน
  Widget appbarProfile(BuildContext context) {
    return Container(
      height: appBarHeight / 1.42,
      width: screenWidthDp,
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () {
                Navigator.pop(context);
              }),
          IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: s60,
              ),
              onPressed: () {
                //showButtonSheet(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OptionSetting()));
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    var data = await userinfo.readContents();
    profile = data;
    setState(() => initInfoFinish = true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Stream<Event> streamTransaction(String uid, String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/$uid/$field').onValue;
  }

  //Run
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: initInfoFinish
            ? Stack(
                children: <Widget>[
                  Container(
                    width: screenWidthDp,
                    padding: EdgeInsets.only(top: appBarHeight / 1.35),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: screenHeightDp / 36),
                          Container(
                            height: screenWidthDp / 3.32,
                            width: screenWidthDp / 3.32,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 1.2),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(screenHeightDp),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(screenHeightDp),
                              child: profile['img'] == null
                                  ? Image.asset('assets/userprofile.png')
                                  : Image.file(File(profile['img']),
                                      fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(height: appBarHeight / 5),
                          Text(
                            '@${profile['id'] ?? 'ชื่อ'}',
                            style:
                                TextStyle(color: Colors.white, fontSize: s60),
                          ),
                          SizedBox(
                            height: appBarHeight / 10,
                          ),
                          Container(
                              child: user.uid == null
                                  ? null
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        dataProfile('เก็บไว้', user.uid,
                                            field: 'pick'),
                                        dataProfile('แอทเทนชัน', user.uid,
                                            field: 'att'),
                                        dataProfile('โดนปาใส่', user.uid,
                                            field: 'thrown'),
                                      ],
                                    )),
                          SizedBox(height: screenHeightDp / 24),
                          FlatButton(
                            child: Text(
                              '${profile['status'] ?? 'สเตตัสของคุณ'}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                  fontStyle: FontStyle.italic),
                            ),
                            onPressed: () {
                              //showPopup(context);
                              // showDialogReport(context);
                            },
                          ),
                          SizedBox(height: screenHeightDp / 24),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidthDp / 30,
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('โดนปาใส่ล่าสุด 9 ก้อน',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: s60)),
                                    Transform.scale(
                                      scale: 1.3,
                                      child: Switch(
                                        value: isSwitched,
                                        onChanged: (value) {
                                          if (value == false) {
                                            Fluttertoast.showToast(
                                                msg: 'ปิดการโดนปาใส่แล้ว');
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: 'เปิดการโดนปาใส่แล้ว');
                                          }
                                          setState(() {
                                            isSwitched = value;
                                          });
                                        },
                                        inactiveTrackColor: Colors.grey,
                                        activeTrackColor: Colors.blue,
                                        activeColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: screenHeightDp / 10,
                                  width: screenWidthDp,
                                  // margin: EdgeInsets.symmetric(
                                  //   vertical: 5,
                                  // ),
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      // Image.asset('assets/paper-mini01.png'),
                                      // Image.asset('assets/paper-mini01.png'),
                                      // Image.asset('assets/paper-mini01.png'),
                                      // Image.asset('assets/paper-mini01.png'),
                                      // Image.asset('assets/paper-mini01.png'),
                                      // Image.asset('assets/paper-mini01.png'),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                      scrap_paper_cube(),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (controller.page != 0)
                                                controller.previousPage(
                                                    duration: Duration(
                                                        milliseconds: 120),
                                                    curve: Curves.ease);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Text('เก็บไว้',
                                                  style:
                                                      // page != 0
                                                      // ?
                                                      // TextStyle(
                                                      //   color: Colors.white,
                                                      //   fontSize: s52,
                                                      //   )
                                                      // :
                                                      TextStyle(
                                                    //decoration: TextDecoration.underline,
                                                    color: Colors.white,
                                                    fontSize: s52,
                                                  )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (controller.page != 1)
                                                controller.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 120),
                                                    curve: Curves.ease);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Text('โดนปาใส่',
                                                  style:
                                                      // page != 1
                                                      // ?
                                                      // TextStyle(
                                                      //   color: Colors.white,
                                                      //   fontSize: s52,
                                                      //   )
                                                      // :
                                                      TextStyle(
                                                    //decoration: TextDecoration.underline,
                                                    color: Colors.white,
                                                    fontSize: s52,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Divider(
                                            color: Colors.white,
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            thickness: 2,
                                            indent: page != 1 ? (9) : (70),
                                            endIndent: page != 1
                                                ? (screenWidthDp - 70)
                                                : (screenWidthDp - 150),
                                            // indent: 9,
                                            // endIndent: screenWidthDp-82,
                                          ),
                                          // Divider(
                                          //   color: Colors.white,
                                          //   thickness: 2,
                                          //   indent: 76,
                                          //   endIndent: screenWidthDp-168,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: screenHeightDp * 1.2,
                            // width: screenWidthDp,
                            child: PageView(
                              onPageChanged: (index) {
                                setState(() => page = index);
                              },
                              controller: controller,
                              children: [
                                Wrapblock(),
                                Wrapblock(),
                              ],
                            ),
                          ),
                          //wrap(),
                        ],
                      ),
                      //user_OtherProfile(),
                    ),
                  ),
                  Positioned(top: 0, child: appbarProfile(context)),
                  adsContainer(),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void showDialogReport(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.symmetric(
                        horizontal: (screenWidthDp - (screenWidthDp / 1.1)) / 2,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: Color(0xffffffff)),
                      child: Icon(
                        Icons.close,
                        color: Colors.blue,
                        size: s48,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: screenHeightDp / 1.7,
                width: screenWidthDp / 1.1,
                decoration: BoxDecoration(
                  color: Color(0xff1a1a1a),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenWidthDp / 50,
                      ),
                      child: Scaffold(
                        backgroundColor: Color(0xff1a1a1a),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Report_DropDownButton(),
                              ),
                              // Row(
                              //   children: [
                              //     // Text(
                              //     //   'ถึงผู้พัฒนา',
                              //     //   style: TextStyle(
                              //     //     fontSize: s60,
                              //     //     color: Colors.white,
                              //     //   ),
                              //     // ),
                              //     //DropDownButton<<<<<<<<<<<<<<<<<<<<<<<
                              //     //Report_DropDownButton(),
                              //   ],
                              // ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: s25, color: Colors.white),
                                  minLines: 17,
                                  maxLines: 17,
                                  decoration: InputDecoration(
                                    // fillColor: Colors.redAccent,
                                    // filled: true,
                                    border: InputBorder.none,
                                    hintText: 'รายงานเจ้าของสแครปรายนี้',
                                    hintStyle: TextStyle(
                                      fontSize: s54,
                                      height: 0.08,
                                      color: Colors.white30,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Positioned(
                                    top: a.width / 0.95,
                                    right: 0,
                                    //bottom: a.height / 10,
                                    // right: 0,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: a.width / 25,
                                        vertical: a.width / 40,
                                      ),
                                      width: a.width / 8,
                                      height: a.width / 8,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Color(0xff26A4FF),
                                          ),
                                          onPressed: () {}),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Container(
                              //       height: 80,
                              //       width: 80,
                              //       margin: EdgeInsets.only(
                              //         right: 5,
                              //         bottom: 5,
                              //       ),
                              //       decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius:
                              //             BorderRadius.circular(screenHeightDp),
                              //       ),
                              //       child: IconButton(
                              //           icon: Icon(
                              //             Icons.send,
                              //             size: 50,
                              //             color: Colors.blue,
                              //           ),
                              //           onPressed: () {}),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeightDp / 18,
                      ),
                      child: Divider(
                        color: Color(0xff383838),
                        thickness: 2,
                        indent: 5,
                        endIndent: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
  //popup หน้า เพิ่มสเตตัส มีปัญหาเรื่อง Textfield

  // _onChanged(String value) {
  //   setState(() {
  //     _charCount = value.length;
  //     print(_charCount);
  //   });
  // }

// StatefulBuilder(
  // builder: (BuildContext context, StateSetter setState)

  //ข้อมูลผู้ใช้
//name = [เก็บไว้, คนให้ความสนใจ, โดนปาใส่]
  Widget dataProfile(String name, String uid, {@required String field}) {
    return SizedBox(
      width: screenWidthDp / 5.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
              stream: streamTransaction(uid, field),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var trans = snapshot.data.snapshot.value;
                  return Text(
                    '$trans',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: s70 * 1.2,
                        fontWeight: FontWeight.bold),
                  );
                } else {
                  return Text(
                    '0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: s70 * 1.2,
                        fontWeight: FontWeight.bold),
                  );
                }
              }),
          Container(
            child: Text(
              name,
              style: TextStyle(
                height: 0.21,
                color: Color(0xfff727272),
                fontWeight: FontWeight.bold,
                fontSize: s36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class A extends StatefulWidget {
//   @override
//   _AState createState() => _AState();
// }

// class _AState extends State<A> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

//โฆษณา Google Ads แสดงด้านล่างสุดของหน้าจอ
Widget adsContainer() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        height: appBarHeight,
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
  );
}

//ก้อนกระดาษ
Widget scrap_paper_cube() {
  return Transform.scale(
    scale: 1.1,
    child: Container(
      margin: EdgeInsets.only(
          //right: 6,
          ),
      width: screenWidthDp / 5.5,
      //height: 20,
      //color: Colors.white,
      child: Image(
        image: AssetImage('assets/paper-mini01.png'),
      ),
    ),
  );
}

class Report_DropDownButton extends StatefulWidget {
  @override
  _Report_DropDownButtonState createState() => _Report_DropDownButtonState();
}

class _Report_DropDownButtonState extends State<Report_DropDownButton> {
  dynamic dropdownValue = 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        value: dropdownValue,
        // style: TextStyle(
        //   color: Colors.white,
        //   fontSize: s36
        // ),
        // dropdownColor: Color(0xff1a1a1a),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: s60,
        //elevation: 16,
        //style: TextStyle(color: Colors.deepPurple),
        // underline: Container(
        //   height: 2,
        //   color: Colors.deepPurpleAccent,
        // ),
        onChanged: (dynamic newValue) {
          setState(
            () {
              dropdownValue = newValue;

              // if (dropdownValue == ' สาธารณะ') {
              //   private = false;
              // } else if (dropdownValue == ' ส่วนตัว') {
              //   private = true;
              // }
            },
          );
        },
        items: <dynamic>[
          'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ',
          'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ',
          'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ',
          'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ',
        ].map<DropdownMenuItem<dynamic>>((dynamic value) {
          if (value == 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else {}
        }).toList(),
      ),
    );
  }
}
