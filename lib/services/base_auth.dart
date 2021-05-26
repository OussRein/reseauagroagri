import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password, String username);

  Future<User> getCurrentUser();

  Future<void> updateEmail(String email);

  Future<void> signOut();

  Future<void> updatePassword(String password);

  Future<void> sendPasswordReset(String email);
}

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getEmail() {
    return _firebaseAuth.currentUser.email;
  }

  String getUserID() {
    return _firebaseAuth.currentUser.uid;
  }

  String getUsername() {
    final uid = _firebaseAuth.currentUser.uid;
    String username = "";
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        final map = new Map<String, dynamic>.from(documentSnapshot.data());
        print("THIS ${map['username']}");
        username = map['username'];
      } else {
        print('Document does not exist on the database');
        username =  'Document does not exist on the database';
      }
    }).onError((error, stackTrace) {print(error);});

    return username;
  }

  Future<String> signIn(String email, String password) async {
    print('i am here!!!!!!!!');
    try {
      final UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = authResult.user;

      return user.uid;
    } catch (error) {
      return error;
    }
  }

  Future<void> updateUsername(String username) async {
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .set({'username': username});
  }

  Future<String> signUp(String email, String password, String username) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = authResult.user;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({'username': username});
    return user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> updateEmail(String email) async {
    User user = FirebaseAuth.instance.currentUser;
    return user.updateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    User user = FirebaseAuth.instance.currentUser;
    return user.updatePassword(password);
  }

  Future<void> sendPasswordReset(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
