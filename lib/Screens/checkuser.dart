/*import 'package:flutter/material.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Screens/homeScreen.dart';
import 'package:pitch/Widgets/drawer.dart';

import 'package:pitch/helper/firebasequeries.dart';

import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pitch/Screens/additionalinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitch/Providers/chatcontacts.dart';
class CheckUser extends StatefulWidget {
  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
   int initial = 0;
  bool isinit = true;
  bool isloading = false;
  var subscription;
  bool nointernet;
  Global global;
   void callinit() {
    global = Provider.of<Global>(context, listen: false);
    if (!global.additonaldone) {
      print('entering');
      /*  setState(() {
        isloading = true;
      });*/

      /*Connectivity().checkConnectivity().then((con) {
        if (con == ConnectivityResult.none) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No Internet Connection')));
        } else {*/

    

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseHelper.getid())
          .get()
          .then((snap) {
        //print(object)
        if (!snap.exists) {
          print('1');
          //Provider.of<Global>(context, listen: false).setuser(true);

          Navigator.of(context).pushReplacementNamed(Additional.routename);
          /* setState(() {
            isloading = false;
          });*/

        } else {
          print('2');
          global.additonaldone = true;

          final contactsdata =
              Provider.of<Contactsdata>(context, listen: false);
          contactsdata.getcontacts(false).then((value) {
            /* setState(() {
              isloading = false;
            });*/
          });
        }
      }).catchError((error) {
        print(error.toString());
      });
    }

    print('right');
  }
  @override

  Widget build(BuildContext context) {

     return /*isloading
        ? Scaffold(
            appBar: AppBar(
              title: Text('Loading'),
            ),
            body: Center(child: CircularProgressIndicator()))*/
        StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (ctx, AsyncSnapshot<ConnectivityResult> snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return Waiting();
              else {
                if (snap.data == ConnectivityResult.none)
                  return Scaffold(
                    body: (Center(
                      child: Text('No Internet Connection'),
                    )),
                  );
                else {
                  callinit();
                  print('call done');
                  return DefaultTabController(
                      initialIndex: initial,
                      length: 2,
                      child: Scaffold(
                        // key: Scaffoldkey,
                        appBar: AppBar(
                          bottom: TabBar(
                            tabs: [
                              Tab(
                                child: Text('Homepage'),
                                icon: Icon(Icons.home),
                              ),
                              Tab(
                                text: 'My Ideas',
                                icon: Icon(Icons.lightbulb),
                              ),
                            ],
                          ),
                          /* actions: [
              PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  onSelected: (bool val) {
                    if (val == true) {
                      logout();
                    }
                  },
                  itemBuilder: (ctx) {
                    return [
                      PopupMenuItem(
                        child: Text('Logout'),
                        value: true,
                      )
                    ];
                  })
            ],*/
                        ),
                        drawer: Drawers(),
                        body: TabBarView(
                          children: [
                            HomeScreen(),
                            ShowMyIdeas(),
                          ],
                        ),
                      ));
                }
              }
            });
   
  }
}*/

 