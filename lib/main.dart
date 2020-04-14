import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/Page/NewWorld.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';
import 'package:scrap/Page/authentication/MainLogin.dart';
import 'package:scrap/Page/authentication/registered/penname/PennameWithPassword.dart';
import 'package:scrap/Page/authentication/not_registered/phone/PhoneWithOTP.dart';
import 'package:scrap/Page/authentication/registered/phone/SetPenname.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenProvider>.value(value: AuthenProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scrap.',
          theme: ThemeData(
              fontFamily: 'ThaiSans', unselectedWidgetColor: Colors.white),
          home: MainPage()),
    );
  }
}
