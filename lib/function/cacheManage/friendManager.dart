import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scrap/services/jsonConverter.dart';

class FriendManager {
  JsonConverter jsonConverter = JsonConverter();

  initFriend(String uid) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document('friends')
        .get()
        .then((doc) async {
      await updateDataAll(doc['friendList'] ?? []);
    });
  }

  updateDataAll(List friends) async {
    List fID = [];
    for (String uid in friends) {
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((doc) async {
        getInfo(fID, uid, doc.data['id']);
      });
    }
    await jsonConverter.writeContent(listm: fID, friends: friends);
  }

  updateData(String uid, int index) async {
    List fID = [];
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .get()
        .then((doc) async {
      await getSingleInfo(fID, uid, doc.data['id'], index);
    });
  }

  getSingleInfo(List list, String uid, String name, int index) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((doc) async {
      await jsonConverter.updateContent(
          id: name,
          imgUrl: doc.data['img'],
          joinD: doc.data['createdDay'],
          index: index);
    });
  }

  getInfo(List list, String uid, String name) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((doc) async {
      list.add({
        'id': name,
        'img': doc.data['img'],
        'join': doc.data['createdDay'].runtimeType == String
            ? doc.data['createdDay']
            : DateFormat('d/M/y').format(doc.data['createdDay'].toDate())
      });
    });
  }
}
