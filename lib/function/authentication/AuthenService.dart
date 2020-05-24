import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/Page/authentication/OTPScreen.dart';
import 'package:scrap/Page/mainstream.dart';
import 'package:scrap/Page/profile/createProfile1.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/others/ResizeImage.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';

final fireStore = Firestore.instance;
final fireAuth = FirebaseAuth.instance;
final fcm = FirebaseMessaging();
final nav = Nav();

class AuthenService {
  PublishSubject<bool> loading = PublishSubject();

  Future<bool> hasAccount(String key, dynamic value) async {
    var doc = await fireStore
        .collection('Account')
        .where(key, isEqualTo: value)
        .limit(1)
        .getDocuments();
    return doc.documents.length > 0;
  }

  Future<QuerySnapshot> getDocuments(String key, dynamic value,
      {String field = 'Account'}) async {
    var doc = await fireStore
        .collection(field)
        .where(key, isEqualTo: value)
        .limit(1)
        .getDocuments();
    return doc;
  }

  Future<void> phoneAuthentication(BuildContext context) async {
    final user = Provider.of<UserData>(context, listen: false);
    loading.add(true);
    var docs = await getDocuments('phone', user.phone);
    user.region = 'th';
    userinfo.initRegion(region: 'th');
    await phoneVerified(context);
    if (docs.documentChanges.length > 0) {
      var userDoc = docs.documents[0];
      user.region = userDoc['region'];
      nav.push(context, OTPScreen());
    } else {
      nav.push(context, OTPScreen(register: true));
    }
  }

  Future<void> phoneVerified(BuildContext context) async {
    final user = Provider.of<UserData>(context, listen: false);
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {};
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      user.verifiedId = id;
      loading.add(false);
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      user.verifiedId != null ? print('use OTP') : print('succese');
    };
    PhoneVerificationFailed failed = (AuthException error) {
      warn('เกิดข้อผิดพลาดกรุณาลองใหม่');
    };
    await fireAuth
        .verifyPhoneNumber(
            phoneNumber: '+66' + user.phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      warn('เกิดข้อผิดพลาดกรุณาลองใหม่');
    });
  }

  Future<void> signUpWithPhone(BuildContext context,
      {@required String smsCode}) async {
    try {
      final user = Provider.of<UserData>(context, listen: false);
      loading.add(true);
      var phoneCredent = PhoneAuthProvider.getCredential(
          verificationId: user.verifiedId, smsCode: smsCode);

      var curUser = await fireAuth.signInWithCredential(phoneCredent);
      user.uid = curUser.user.uid;
      await fireStore
          .collection('Account')
          .document(curUser.user.uid)
          .setData({'phone': user.phone, 'region': user.region}, merge: true);
      nav.pushReplacement(context, CreateProfile1());
      loading.add(false);
    } catch (e) {
      print(e.toString());
      switch (e.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          warn('ตรวจสอบการเชื่อมต่อ');
          break;
        case 'ERROR_INVALID_VERIFICATION_CODE':
          warn('เช็คใหม่');
          break;
        default:
          warn('OTPอาจหมดอายุ');
          break;
      }
    }
  }

  signInWithPhone(BuildContext context, {@required String smsCode}) async {
    try {
      final userData = Provider.of<UserData>(context, listen: false);
      loading.add(true);
      var credent = PhoneAuthProvider.getCredential(
          verificationId: userData.verifiedId, smsCode: smsCode);
      var curUser = await fireAuth.signInWithCredential(credent);
      var uid = curUser.user.uid;
      userData.uid = uid;
      initFriends(context);
      cacheHistory.initHistory();
      await updateToken(uid);
      await checkFinishSignUp(context);
    } catch (e) {
      print(e.toString());
      // switch (e.code) {
      //   case 'ERROR_NETWORK_REQUEST_FAILED':
      //     warn('ตรวจสอบการเชื่อมต่อ');
      //     break;
      //   case 'ERROR_INVALID_VERIFICATION_CODE':
      //     warn('เช็คใหม่');
      //     break;
      //   default:
      //     warn('OTPอาจหมดอายุ');
      //     break;
      // }
    }
  }

  Future<void> signInWithID(BuildContext context,
      {@required String id, @required String password}) async {
    final user = Provider.of<UserData>(context, listen: false);
    loading.add(true);
    var docs = (await getDocuments('id', id)).documents;
    if (docs.length > 0) {
      if (docs[0]['password'] == password) {
        initFriends(context);
        cacheHistory.initHistory();
        user.region = docs[0]['region'];
        userinfo.initRegion(region: docs[0]['region']);
        var uid = docs[0].documentID;
        fireAuth.signInWithEmailAndPassword(
            email: '$uid@gmail.com', password: password);
        await updateToken(uid);
        await checkFinishSignUp(context);
      } else
        warn('ตรวจสอบรหัสผ่านของคุณ');
    } else
      warn('ไม่พบบัญชีดังกล่าว');
  }

  Future<void> setAccount(BuildContext context,
      {@required DateTime birthday, @required String gender}) async {
    loading.add(true);
    var token = await getToken();
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    final userData = Provider.of<UserData>(context, listen: false);
    var user = await fireAuth.currentUser();
    String uid = user.uid;
    var accRef = fireStore.collection('Account').document(uid);
    var userRef =
        fireStore.collection('Users/${userData.region}/users').document(uid);
    var infoRef = fireStore
        .collection('Users/${userData.region}/users/$uid/info')
        .document(uid);
    var batch = fireStore.batch();
    if (userData.img.runtimeType != String) {
      var resizeImg = await resize.resize(image: userData.img, quality: 32);
      userData.img = await resize.uploadImg(
          img: resizeImg, imageName: uid + '/' + '${uid}_pro0');
    }
    initFile(context);
    cacheHistory.initHistory();
    userDb.reference().child('users/$uid').set(
        {'att': 0, 'papers': 15, 'pick': 0, 'thrown': 0, 'allowThrow': false});
    userDb
        .reference()
        .child('users/$uid/follows')
        .set({'followers': 0, 'following': 0});
    batch.setData(
        accRef,
        {
          'password': userData.password,
          'id': userData.id,
          'region': userData.region,
          'token': token
        },
        merge: true);
    batch.setData(
        infoRef,
        {
          'region': userData.region,
          'birthday': birthday,
          'gender': gender,
          'created': FieldValue.serverTimestamp(),
          'imgList': FieldValue.arrayUnion([userData.img])
        },
        merge: true);
    batch.setData(userRef, {'id': userData.id, 'img': userData.img},
        merge: true);
    await batch.commit();

    var emailCredent = EmailAuthProvider.getCredential(
        email: '$uid@gmail.com', password: userData.password);
    await user.linkWithCredential(emailCredent);
    loading.add(false);

    nav.pushReplacement(context, MainStream());
  }

  Future<void> checkFinishSignUp(BuildContext context) async {
    final user = Provider.of<UserData>(context, listen: false);
    var doc = await fireStore
        .collection('Users/${user.region}/users')
        .document(user.uid)
        .get();
    if (doc.exists) {
      var map = doc.data;
      doc.data['region'] = user.region;
      await userinfo.initUserInfo(doc: map);
      loading.add(false);
      nav.pushReplacement(context, MainStream());
    } else {
      loading.add(false);
      nav.pushReplacement(context, CreateProfile1());
    }
  }

  void initFile(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    userinfo.initUserInfo(doc: {
      'img': user.img,
      'id': user.id,
      'status': '',
      'region': user.region
    });
    cacheFriends.intitFile();
  }

  Future<void> initFriends(BuildContext context) async {
    final user = Provider.of<UserData>(context, listen: false);
    var docs = await fireStore
        .collection('Users/${user.region}/users/${user.uid}/following')
        .getDocuments();
    if (docs.documents.length > 0)
      for (var doc in docs.documents) {
        cacheFriends.addFollowing(following: doc['list']);
      }
  }

  Future<String> getToken() async {
    return fcm.getToken();
  }

  Future<void> updateToken(String uid) async {
    var token = await getToken();
    await Firestore.instance
        .collection('Account')
        .document(uid)
        .setData({'token': token}, merge: true);
  }

  ///sign current user out then laed to [AuthenPage]
  Future<void> signOut(BuildContext context) async {
    loading.add(true);
    await userinfo.deleteFile();
    await cacheHistory.deleteFile();
    await fireAuth.signOut();
    nav.pushReplacement(context, LoginPage());
    loading.add(false);
  }

  warn(String text) {
    loading.add(false);
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

final authService = AuthenService();
