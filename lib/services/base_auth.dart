import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password, String username);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordReset(String email);
}

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    print('i am here!!!!!!!!');
    try {
      final UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User user = authResult.user;
    
    return user.uid;
    } catch (error){
      return error;
    }
  }

  Future<String> signUp(String email, String password, String username) async {
    final UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = authResult.user;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'username': username});
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

  updateEmail(String value) async {
    User user = FirebaseAuth.instance.currentUser;
    user.updateEmail(value);

  }

  Future<bool> isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.emailVerified;
  }

  Future<void> sendPasswordReset(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}