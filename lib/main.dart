import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/provider/AdsCounter.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';

const String testDevice = "34C215009965F34F";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //this is new branch
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdsCounterProvider>.value(
            value: AdsCounterProvider()),
        ChangeNotifierProvider<RealtimeDB>.value(value: RealtimeDB()),
        ChangeNotifierProvider<Report>.value(value: Report()),
        ChangeNotifierProvider<UserData>.value(value: UserData()),
        ChangeNotifierProvider<WriteScrapProvider>.value(
            value: WriteScrapProvider())
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
