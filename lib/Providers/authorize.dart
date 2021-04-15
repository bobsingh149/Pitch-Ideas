import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime expiry;
  String userid;
  //Duration expin;
  Timer authtimer;

  Auth();

  String get token {
    if (_token != null && expiry != null && expiry.isAfter(DateTime.now()))
      return _token;

    return null;

 
  }

  bool get isauth {
    return token != null;
  }

  Future<void> signup(String id, String password) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDb-LPtKb7BzPDNfDgL3AhFyDftHQmRgS0');

    try {
        
      var response = await http.post(url,
          body: jsonEncode({
            'email': id,
            'password': password,
            'returnSecureToken': true,
          }));
      var resbody = jsonDecode(response.body);

      _token = resbody['idToken'];

      //expin = Duration(seconds: int.parse(resbody['expiresIn']));

      expiry = DateTime.now()
          .add(Duration(seconds: int.parse(resbody['expiresIn'])));
      userid = resbody['localId'];

      print('response status ${response.statusCode}');
      print('response body ${response.body}');

      var shared = await SharedPreferences.getInstance();

      var userauthdata = jsonEncode({
        'userid': this.userid,
        'token': this._token,
        'expiry': this.expiry.toIso8601String(),
      });

      shared.setString('userauth', userauthdata);
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
      autologout();
    }
  }

  Future<void> signin(String id, String password) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDb-LPtKb7BzPDNfDgL3AhFyDftHQmRgS0');

    try {
      var response = await http.post(url,
          body: jsonEncode({
            'email': id,
            'password': password,
            'returnSecureToken': true,
          }));

      var resbody = jsonDecode(response.body);

      _token = resbody['idToken'];
      expiry = DateTime.now()
          .add(Duration(seconds: int.parse(resbody['expiresIn'])));

      userid = resbody['localId'];

      print('response status ${response.statusCode}');
      print('response body ${response.body}');
      var shared = await SharedPreferences.getInstance();

      var userauthdata = jsonEncode({
        'userid': this.userid,
        'token': this._token,
        'expiry': this.expiry.toIso8601String(),
      });

      shared.setString('userauth', userauthdata);

      autologout();
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> autologin() async {
    //if you do not await it contains future<T> that is executed in future
    //if you await it contains T what will future will resolve to

    final sharedprefences = await SharedPreferences.getInstance();

    if (!sharedprefences.containsKey('userauth')) return false;

    final extractedData = jsonDecode(sharedprefences.getString('userauth'));

    final exp = DateTime.parse(extractedData['expiry']);

    if (exp.isBefore(DateTime.now())) return false;

    this.expiry = exp;
    this._token = extractedData['token'];
    this.userid = extractedData['userid'];

    notifyListeners();
    autologout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    expiry = null;
    userid = null;

    if (authtimer != null) {
      authtimer.cancel();
      authtimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autologout() {
    if (authtimer != null) authtimer.cancel();

    var expin = expiry.difference(DateTime.now()).inSeconds;
    authtimer = Timer(Duration(seconds: expin), logout);
    //after some time t executes this function
  }
}
