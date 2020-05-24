import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user
        .uid;
  }

  @override
  Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser())?.uid ?? '';
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user
        .uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
