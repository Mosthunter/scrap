import 'dart:async';
import 'dart:wasm';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/wrap.dart';
import 'package:scrap/widget/ScreenUtil.dart';

//textfield popup
void showPopup(BuildContext context) {
  int _charCount = 0;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter a) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: screenHeightDp / 2,
                  width: screenWidthDp / 1.1,
                  /*   decoration: BoxDecoration(
                    //  color: Color(0xff1a1a1a),
                    /* color: Colors.black,
                  borderRadius: BorderRadius.circular(5),*/
                    ),*/
                  child: Container(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomPadding: false,
                      body: Container(
                        width: screenWidthDp,
                        height: appBarHeight * 3.65,
                        decoration: BoxDecoration(
                            color: Color(0xff1a1a1a),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '\t\tเพิ่มสเตตัส',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: s52,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(right: appBarHeight / 10),
                                  child: GestureDetector(
                                      child: Container(
                                        height: appBarHeight / 2.8,
                                        width: appBarHeight / 2.8,
                                        decoration: BoxDecoration(
                                            color: Color(0xfff000000),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(appBarHeight))),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.blue,
                                          size: s42,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            ),
                            Divider(
                              height: 5.0,
                              color: Color(0xfff707070),
                            ),
                            SizedBox(
                              height: appBarHeight / 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                ),
                                minLines: 4,
                                maxLines: 4,
                                maxLength: 60,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color(0xff222222),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  hintText: 'เขียนข้อความของคุณ',
                                  hintStyle: TextStyle(
                                    fontSize: s48,
                                    height: 0.08,
                                    color: Color(0xfffA2A2A2),
                                    //color: AppColors.textFieldInput
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                ),
                                onChanged: (String value) {
                                  a(() {
                                    _charCount = value.length;
                                    print(_charCount);
                                  });
                                },
                              ),
                              width: appBarHeight * 4.2,
                              height: appBarHeight * 2.3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: screenWidthDp / 5,
                                  height: appBarHeight / 2.3,
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Center(
                                    child: Text(
                                      ' ' + _charCount.toString() + '\t/\t60 ',
                                      style: TextStyle(
                                        color: Colors.white30,
                                        fontSize: s42,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: appBarHeight,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        appBarHeight / 3,
                                        appBarHeight / 25,
                                        appBarHeight / 3,
                                        appBarHeight / 25),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff26A4FF),
                                        borderRadius: BorderRadius.circular(
                                            screenHeightDp)),
                                    child: Center(
                                      child: Text(
                                        'เพิ่ม',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: s48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      });
}

//การตั้งค่า
class OptionSetting extends StatefulWidget {
  @override
  _OptionSettingState createState() => _OptionSettingState();
}

class _OptionSettingState extends State<OptionSetting> {
  StreamSubscription loadStatus;
  bool loading = false;

  @override
  void initState() {
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      //resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: appBarHeight / 2,
                    ),
                    appbarOptionSetting(context),
                    list_OptionSetting(context, Icons.face,
                        ' จัดการบัญชีของฉัน', Manage_MyProfile()),
                    list_OptionSetting(context, Icons.history,
                        ' ประวัติการเขียนสแครป', HistoryScrap_MyProfile()),
                    list_OptionSetting(context, Icons.description,
                        ' ข้อกำหนดการให้บริการ', ComingSoon()),
                    list_OptionSetting(context, Icons.extension,
                        ' อธิบายฟีเจอร์', ComingSoon()),
                    list_OptionSetting(context, Icons.markunread,
                        ' สารจากผู้พัฒนา', ComingSoon()),
                    list_OptionSetting(context, Icons.bug_report,
                        ' แจ้งปัญหาระบบ', ReportToScrap_MyProfile()),
                    list_OptionSetting(context, Icons.block, ' ประวัติการบล็อค',
                        BlockUser_MyProfile()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ComingSoon()));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: appBarHeight / 10),
                        /*   margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          //vertical: 5,
                        ),*/
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: appBarHeight / 1.5,
                                    child: Image.asset(
                                      'assets/bualoi.png',
                                      scale: 5,
                                    )),
                                Text(
                                  'เกี่ยวกับ Bualoitech Co.,Ltd.',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: s60),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: appBarHeight) / 5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: s54,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //ออกจากระบบ
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(left: appBarHeight / 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: appBarHeight / 1.5,
                                        child: Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                          size: s70,
                                        ),
                                      ),
                                      Text(
                                        'ออกจากระบบ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: s60),
                                      )
                                    ])
                              ])),
                      onTap: () {
                        authService.signOut(context);
                      },
                    ),
                  ],
                ),
                /* SizedBox(
                  height: appBarHeight * 1,
                ),*/
                Column(
                  children: [
                    SizedBox(
                      height: appBarHeight / 1,
                    ),
                    GestureDetector(
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/scrapbig.png',
                          scale: appBarHeight / 10,
                        ),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                    Text(
                      'version 2.0.1\n\n',
                      style: TextStyle(color: Colors.white, fontSize: s58),
                    ),
                  ],
                ),
              ],
            ),
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }
}

Widget appbarOptionSetting(BuildContext context) {
  return Container(
    height: appBarHeight / 1.35,
    width: screenWidthDp,
    margin: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 100,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: s60,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        Text(
          'การตั้งค่า',
          style: TextStyle(
            fontSize: s60,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            //color: Colors.white,
          ),
          onPressed: null,
        ),
      ],
    ),
  );
}

// list_OptionSetting เป็น Widget ที่แสดงลิสต์ต่างๆในการตั้งค่า
// (context , ชื่อicon, ชื่อการตั้งค่า, หน้าstatefulที่หลังจากกด)
//  หน้า stateful บางหน้าที่เป็น web view จะเชื่อมต่อไปหน้า stateful ที่ชื่อ ComingSoon()
Widget list_OptionSetting(context, icon, name, stateful) {
  return FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => stateful));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          //horizontal: 10,
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: s70,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: s60),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: s54,
            )
          ],
        ),
      ));
}

// Appbar ในหน้า statefulต่างๆ ที่หลังจากกด
Widget appbar_ListOptionSetting(BuildContext context, icon, name) {
  return Container(
    height: appBarHeight / 1.35,
    width: screenWidthDp,
    margin: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 100,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: s60,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: s52,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: s60,
                color: Colors.white,
              ),
            ),
          ],
        ),
        IconButton(
            icon: Icon(
              Icons.more_horiz,
              //color: Colors.white,
            ),
            onPressed: null),
      ],
    ),
  );
}

//หน้า จัดการบัญชีของฉัน
class Manage_MyProfile extends StatefulWidget {
  @override
  _Manage_MyProfileState createState() => _Manage_MyProfileState();
}

class _Manage_MyProfileState extends State<Manage_MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Container(
            height: appBarHeight / 2,
          ),
          appbar_ListOptionSetting(context, Icons.face, ' จัดการบัญชีของฉัน'),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            height: screenHeightDp / 5.5,
            width: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff1a1a1a),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenWidthDp / 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: screenWidthDp / 4,
                    width: screenWidthDp / 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenHeightDp),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '@naveeharn',
                        style: TextStyle(
                          fontSize: s60,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Join 15/02/2020',
                        style: TextStyle(
                          fontSize: s60,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: appBarHeight / 15,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            height: screenHeightDp / 3,
            width: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff1a1a1a),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: Text(
                              'เพิ่มสเตตัส',
                              style: TextStyle(
                                fontSize: s48,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              showPopup(context);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: screenHeightDp / 3.85,
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xff222222),
                  ),
                  child: Center(
                    child: Text(
                      'ไม่รู้อะไร',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: s42,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            height: screenHeightDp / 4.5,
            width: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff1a1a1a),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'เบอร์โทรศัพท์',
                  style: TextStyle(
                    fontSize: s42,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '044-112-1011',
                  style: TextStyle(
                    fontSize: s65,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: s52,
                    ),
                    Text(
                      ' เปลี่ยนเบอร์โทรศัพท์',
                      style: TextStyle(
                        fontSize: s42,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: appBarHeight / 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: s52,
                    ),
                    Text(
                      ' เปลี่ยนรหัสผ่าน',
                      style: TextStyle(
                        fontSize: s42,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// หน้า ประวัติการเขียนสแครป
class HistoryScrap_MyProfile extends StatefulWidget {
  @override
  _HistoryScrap_MyProfileState createState() => _HistoryScrap_MyProfileState();
}

class _HistoryScrap_MyProfileState extends State<HistoryScrap_MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            appbar_ListOptionSetting(
                context, Icons.history, ' ประวัติการเขียนสแครป'),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(top: appBarHeight / 1.35),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrapblock(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Grid กระดาษ
Widget wrap() {
  return Wrap(
    direction: Axis.horizontal,
    alignment: WrapAlignment.center,
    children: <Widget>[
      Paper_Widget(),
      Paper_Widget(),
      TimeOut_Paper_Widget(),
      TimeOut_Paper_Widget(),
      TimeOut_Paper_Widget(),
      TimeOut_Paper_Widget(),
      TimeOut_Paper_Widget(),
      TimeOut_Paper_Widget(),
    ],
  );
}

Widget wrap2() {
  return Column(
    children: [
      Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: <Widget>[
          Paper_Widget(),
          TimeOut_Paper_Widget(),
          TimeOut_Paper_Widget(),
          TimeOut_Paper_Widget(),
          TimeOut_Paper_Widget(),
          TimeOut_Paper_Widget(),
          TimeOut_Paper_Widget(),
        ],
      ),
    ],
  );
}

//กระดาษที่ยังไม่หมดเวลา
class Paper_Widget extends StatelessWidget {
  //final String text;
  //Ads_Widget(this.text);
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(4),
      // width: (174/209)*220,
      // height: (209/174)*220,
      width: a.width / 2.2,
      height: (a.width / 2.1) * 1.21,
      color: Colors.yellow.shade700,
      //child: Center(child: Text(text)),
    );
  }
}

//กระดาษที่หมดเวลาแล้ว
class TimeOut_Paper_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(4),
          // width: (174/209)*220,//screenWidthDp / 2.2,
          // height: (209/174)*220,//screenHeightDp / 4,
          width: a.width / 2.2,
          height: (a.width / 2.1) * 1.21,
          color: Colors.yellow.shade700,
        ),
        Container(
          margin: EdgeInsets.all(4),
          // width: (174/209)*220,//screenWidthDp / 2.2,
          // height: (209/174)*220,//screenHeightDp / 4,
          width: a.width / 2.2,
          height: (a.width / 2.1) * 1.21,
          color: Colors.black38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 50,
                color: Colors.white,
              ),
              Text(
                'หมดเวลา',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s48,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// หน้า แจ้งปัญหาระบบ
class ReportToScrap_MyProfile extends StatefulWidget {
  @override
  _ReportToScrap_MyProfileState createState() =>
      _ReportToScrap_MyProfileState();
}

class _ReportToScrap_MyProfileState extends State<ReportToScrap_MyProfile> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: appBarHeight / 2,
              ),
              appbar_ListOptionSetting(
                  context, Icons.bug_report, ' แจ้งปัญหาระบบ'),
              Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                height: screenHeightDp / 1.5,
                width: screenWidthDp / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff202020),
                ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ถึงผู้พัฒนา',
                            style: TextStyle(
                              fontSize: s60,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: TextField(
                          style: TextStyle(fontSize: s52, color: Colors.white),
                          minLines: 10,
                          maxLines: 10,
                          decoration: InputDecoration(
                            // fillColor: Colors.redAccent,
                            // filled: true,
                            border: InputBorder.none,
                            hintText: 'แจ้งรายละเอียดเกี่ยวกับปัญหา',
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
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(left: appBarHeight / 15),
                              margin: EdgeInsets.symmetric(
                                horizontal: a.width / 40,
                                vertical: a.width / 40,
                              ),
                              width: a.width / 8,
                              height: a.width / 8,
                              //alignment: Alignment.center,
                              child: Icon(
                                Icons.send,
                                color: Color(0xff26A4FF),
                                size: s60 * 0.8,
                              ),

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(a.width)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeightDp / 5.2,
            ),
            child: Divider(
              color: Color(0xff383838),
              thickness: 2,
              indent: 25,
              endIndent: 25,
            ),
          ),
        ],
      ),
    );
  }
}

// หน้า ประวัติการบล็อค
class BlockUser_MyProfile extends StatefulWidget {
  @override
  _BlockUser_MyProfileState createState() => _BlockUser_MyProfileState();
}

class _BlockUser_MyProfileState extends State<BlockUser_MyProfile> {
  Widget blockUser(username) {
    return Container(
      margin: EdgeInsets.only(
        left: screenWidthDp / 20,
        //top: 5,
        bottom: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenHeightDp),
                ),
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: s42,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          FlatButton(
            onPressed: () {},
            child: Container(
              width: appBarHeight * 1.2,
              height: appBarHeight / 2.3,
              padding: EdgeInsets.fromLTRB(appBarHeight / 20, appBarHeight / 20,
                  appBarHeight / 120, appBarHeight / 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenHeightDp),
              ),
              child: Text(
                'ปลดบล๊อค',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: s42,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: appbar_ListOptionSetting(
                    context, Icons.block, ' ประวัติการบล็อค'),
              ),
              Positioned(
                //top: appBarHeight / 1.35,
                child: Container(
                  padding: EdgeInsets.only(top: appBarHeight / 1.35),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

// หน้า ComingSoon
class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: appBarHeight / 2,
              ),
              Container(
                height: appBarHeight,
                width: screenWidthDp,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidthDp / 100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              child: Text(
                'C O M I N G S O O N',
                style: TextStyle(fontSize: s70, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
