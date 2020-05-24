import 'dart:io';

class AdmobService {
  String getAdmobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3612265554509092~4730522974';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092~5449650222';
    }
    return null;
  }

  String getBannerAdId() {
     if (Platform.isIOS){
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getVideoAdId(){
    if (Platform.isIOS){
      return 'ca-app-pub-3940256099942544/8691691433';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8691691433';
    }
    return null;
  }
}

final ads = AdmobService();



/*
String getAdmobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3612265554509092~4730522974';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092~5449650222';
    }
    return null;
  }

  String getBannerAdId() {
     if (Platform.isIOS){
      return 'ca-app-pub-3612265554509092/4043772045';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092/3753425177';
    }
    return null;
  }

  String getVideoAdId(){
    if (Platform.isIOS){
      return 'ca-app-pub-3612265554509092/8652228758';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3612265554509092/6245525449';
    }
    return null;
  }*/