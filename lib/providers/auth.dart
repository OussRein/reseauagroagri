import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _experationDate;
  String _userId;
  Timer _authTimer;
  
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_experationDate != null &&
        _token != null &&
        _experationDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String segment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyBAucpXxVIpuPOziNbwNI-JDEKGqP5o7jM');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final authData = json.decode(response.body);
      if (authData['error'] != null) {
        throw HttpException(authData['error']['message']);
      }
      _token = authData['idToken'];

      _userId = authData['localId'];
      _experationDate = DateTime.now()
          .add(Duration(seconds: int.parse(authData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'experationDate': _experationDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _experationDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _experationDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();

    if(!prefs.containsKey('userData')) return false;

    final userData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final experationDate = DateTime.parse(userData['experationDate']);
    if(experationDate.isBefore(DateTime.now())) return false;

    _token = userData['token'];
    _userId = userData['userId'];
    _experationDate = experationDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
