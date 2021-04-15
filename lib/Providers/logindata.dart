import 'package:flutter/material.dart';

class LoginData with ChangeNotifier {
  Map<String, String> _userdata = {'admin': 'singh14'};

  void add(String user, String password) {
    _userdata[user] = password;
    notifyListeners();
  }

  int get length {
    return _userdata.length;
  }

  Map<String, String> get usersdata {
    return {..._userdata};
  }

  bool authorize(String username, String password) {
    if (_userdata.containsKey(username) && _userdata[username] == password)
      return true;
    else
      return false;
  }
}
