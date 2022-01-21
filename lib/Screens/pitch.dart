import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/category.dart';
import 'package:pitch/Widgets/catItem.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum filteroptions {
  customized,
  all,
}

class Pitch extends StatefulWidget {
  static const routename = '/pitch';

  @override
  _PitchState createState() => _PitchState();
}

class _PitchState extends State<Pitch> {
  /*bool favorite;

  @override
  initState() {
    favorite=fav;
    super.initState();
  }*/
  bool isinit = true;
  bool fav = false;
  bool isloading = false;
  CategoryData categoryData;
  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });

      categoryData = Provider.of<CategoryData>(context);

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseHelper.getid())
          .get()
          .then((s) {
        fav = s.get('iscustomized');

        categoryData.initilize().then((value) {
          setState(() {
            isloading = false;
          });
        });
      });
    }

    isinit = false;

    super.didChangeDependencies();
  }

  Future<void> setfav(bool customized) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseHelper.getid())
        .update({'iscustomized': customized});
  }

  Widget build(BuildContext context) {
    //print('Pitch build method');
    final CategoryData categoryobject = Provider.of<CategoryData>(context);

    //we are using the same object created in main we are not
    //creating object again and again
    //because its is global data so only 1 object

    return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              'Select The Category',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (filteroptions value) async {
                  if (value == filteroptions.customized) {
                    setState(() {
                      fav = true;
                    });

                    await setfav(true);
                  } else {
                    setState(() {
                      fav = false;
                    });

                    await setfav(false);
                  }
                },
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      child: Text('Customized to me'),
                      value: filteroptions.customized,
                    ),
                    PopupMenuItem(
                      child: Text('Show all'),
                      value: filteroptions.all,
                    ),
                  ];
                })
          ],
        ),
        body: isloading
            ? Center(child: CircularProgressIndicator())
            : GridView(
                children: fav
                    ?categoryobject.favorites.isEmpty  ?[Text('No category marked favorite yet',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),)]
                    :categoryobject.favorites.map((current) {
                        return CatItem(
                          id: current.id,
                          title: current.title,
                          url: current.url,
                          setfav: categoryobject.setfavorite,
                          c: current,
                          isfavorite: current.isfav,
                        );
                      }).toList()
                    : categoryobject.category.map((current) {
                        return CatItem(
                          id: current.id,
                          title: current.title,
                          url: current.url,
                          setfav: categoryobject.setfavorite,
                          c: current,
                          isfavorite: current.isfav,
                        );
                      }).toList(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  //childAspectRatio: 0.3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
              ));
  }
}
