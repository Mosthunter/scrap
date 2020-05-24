import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class RealtimeDB extends ChangeNotifier {
  FirebaseApp _scrapAll;
  FirebaseApp _userTransact;

  FirebaseApp get scrapAll => _scrapAll;
  FirebaseApp get userTransact => _userTransact;

  set scrapAll(FirebaseApp val) {
    _scrapAll = val;
    notifyListeners();
  }

  set userTransact(FirebaseApp val) {
    _userTransact = val;
    notifyListeners();
  }
}
