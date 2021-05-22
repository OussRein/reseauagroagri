import 'package:firebase_auth/firebase_auth.dart';


abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordReset(String email);
}

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    final UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User user = authResult.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    final UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = authResult.user;
    return user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.emailVerified;
  }

  Future<void> sendPasswordReset(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}