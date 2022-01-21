import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Screens/ShowMyIdeas.dart';
import 'package:pitch/Screens/additionalinfo.dart';
import 'package:pitch/Screens/homeScreen.dart';
import 'package:pitch/Widgets/drawer.dart';

import 'package:pitch/Providers/globalData.dart';

import 'package:pitch/helper/firebasequeries.dart';

import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class Tabs extends StatefulWidget {
  static const String routename = '/tabs';
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int initial = 0;
  bool isinit = true;
  bool isloading = false;

  /* @override
  void didChangeDependencies() {
    if (isinit) {
      final global = Provider.of<Global>(context);

      if (global.isnewuser) {
        global.setuser(false);
        Navigator.of(context).pushReplacementNamed(Additional.routename);
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }*/

  @override
  void didChangeDependencies() {
    //print(widget.signout);
    final global = Provider.of<Global>(context, listen: false);
    if (isinit && !global.additonaldone) {
     // print('entering');
      setState(() {
        isloading = true;
      });

      FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseHelper.getid())
              .get()
              .then((snap) {
            //print(object)
            if (!snap.exists) {
              //print('1');
              //Provider.of<Global>(context, listen: false).setuser(true);

              Navigator.of(context).pushReplacementNamed(Additional.routename);
              /* setState(() {
            isloading = false;
          });*/

            } else {
             // print('2');
              global.additonaldone = true;

              final contactsdata =
                  Provider.of<Contactsdata>(context, listen: false);
              contactsdata.getcontacts().then((value) {
                contactsdata.getMyInvestment().then((value) => {
                                  setState(() {
                  isloading = false;
                })


                });
              });
            }
          }).catchError((error) {
            print(error.toString());
          });

      
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments;
    if (data != null) {
      initial = data;
    }

    return isloading
        ? Scaffold(
            appBar: AppBar(
              title: Text('Loading'),
            ),
            body: Center(child: CircularProgressIndicator()))
        : DefaultTabController(
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
