import 'package:flutter/material.dart';

class Global with ChangeNotifier {
  bool _isnewuser = false;
  bool additonaldone = false;
  bool initideas = false;

  bool get isnewuser {
    return _isnewuser;
  }

  void setuser(bool isnew) {
    _isnewuser = isnew;
  }

  void clear() {
    _isnewuser = false;
    additonaldone = false;
    initideas = false;
  }
}
