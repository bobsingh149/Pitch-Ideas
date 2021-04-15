import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Screens/TabScreen.dart';
import 'package:pitch/Screens/additionalinfo.dart';
import 'package:pitch/Screens/login.dart';
import 'package:pitch/Screens/waiting.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class First extends StatefulWidget {
  static const routename = '/1';

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  bool isinit = true;
  bool isloading = false;

 

  @override
  Widget build(BuildContext context) {
    return 
        
         StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else {
                if (snapshot.hasData) {
                  print('has data');
                  /*if (global.isnewuser != null)
                                 // global.isnewuser == false)
                                return HomeScreen();

                              else*/
                  if (Provider.of<Global>(context).isnewuser)
                    return Additional();
                  else
                    return Tabs();
                } else {
                  print('doesn\'t has data');
                  return Login();
                }
              }
            });
  }
}
