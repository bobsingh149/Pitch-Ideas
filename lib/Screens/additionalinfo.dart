import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Screens/TabScreen.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:pitch/Widgets/imageinput.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class Additional extends StatefulWidget {
  static const routename = '/additonal';
  @override
  _AdditionalState createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {
  String gender = 'male';
  String countryname;
  String name;
  bool isloading = false;
  int age;
  bool c1 = false;
  bool c2 = false;
  bool c3 = false;
  File userpic;
  String url = 'na';
  List<String> professions = [
    'Arts and entertainment',
    'Business',
    'Industrial and manufacturing',
    'Healthcare and medicine',
    'Government Services',
    'Science and technology',
    'Student',
    'IT Sector'
  ];
  String profession = 'Student';
  final formkey = GlobalKey<FormState>();
  bool edit = false;
  Future<void> saveform() async {
    if (!formkey.currentState.validate()) return;

    if (countryname == null) return;

    formkey.currentState.save();

    // FocusScope.of(context).unfocus();
   // print('user additional info');
    //print(gender);
    //print(countryname);
    //print(name);
    //print(age);

    setState(() {
      isloading = true;
    });

    if (edit) {
      /* FirebaseHelper.update(
          collectionpath: 'users/${FirebaseHelper.getid()}',
          data: {
            'name': name,
            'age': age,
            'country': countryname,
            'gender': gender,
            'profession': profession,
          });*/
    } else {
      if (userpic != null) {
        await FirebaseStorage.instance
            .ref('users/${FirebaseHelper.getid()}')
            .putFile(userpic);

        url = await FirebaseStorage.instance
            .ref('users/${FirebaseHelper.getid()}')
            .getDownloadURL();
      }

      try {
        await FirebaseHelper.addwithid(
            collectionpath: 'users',
            itemid: FirebaseHelper.getid(),
            data: {
              'name': name,
              'age': age,
              'country': countryname,
              'gender': gender,
              'profession': profession,
              'iscustomized': false,
              'url': url,
              '1': false,
              '2': false,
              '3': false,
              '4': false,
              '5': false,
              '6': false,
              '7': false,
            });
      } catch (error) {
        print('error');
        print(error);
      }
    }

    Provider.of<Global>(context,listen: false).additonaldone=true;
    Navigator.of(context).pushReplacementNamed(Tabs.routename);
  }

  void setimage(File image) {
    userpic = image;
  }

  /* Future<void> testing() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users/${FirebaseHelper.getid()}/ideas')
          .where('title', isEqualTo: 'Pitch')
          .limit(1)
          .get();

      final ideaslist = snapshot.docs;

      for (int i = 0; i < ideaslist.length; i++) {
        print(ideaslist[i].data());
      }
    } catch (error) {
      print(error);
    }

    //${FirebaseHelper.getid()}/ideas')
    //.get(GetOptions());
    // .where('title', isEqualTo: 'Pitch');

    /*final ideaslist = snapshot.docs;

    for (int i = 0; i < ideaslist.length; i++) {
      print(ideaslist[i]);
    }*/
  }*/

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode1 = FocusNode();
    FocusNode focusNode2 = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title:
            FittedBox(child: Text('We need to collect some additional info')),
        actions: [
          IconButton(icon: Icon(Icons.navigate_next), onPressed: saveform)
        ],
      ),
      //drawer: Drawers(),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                      key: formkey,
                      child: Container(
                        height: 250,
                        //  color: Colors.amber,
                        child: ListView(
                          children: [
                            /* Checkbox(
                          value: c1,
                          onChanged: (newval) {
                            setState(() {
                              c1 = newval;
                            });
                          }),
                      Checkbox(value: c2, onChanged:(newval) {
                            setState(() {
                              c2 = newval;
                            });
                          }), 
                      Checkbox(value: c3, onChanged: (newval) {
                            setState(() {
                              c3 = newval;
                            });
                          }),*/
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'What should we call you'),
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusNode2);
                              },
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'This field cannot be empty';
                                else
                                  return null;
                              },
                              onSaved: (val) {
                                name = val;
                              },
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Tell your age'),

                              //onEditingComplete: (){FocusScope.of(context).requestFocus()},

                              keyboardType: TextInputType.phone,

                              onFieldSubmitted: (val) {
                                FocusScope.of(context).unfocus();
                              },

                              textInputAction: TextInputAction.done,

                              validator: (val) {
                                if (val.isEmpty)
                                  return 'This field cannot be empty';
                                else
                                  return null;
                              },

                              onSaved: (val) {
                                age = int.parse(val);
                              },

                              focusNode: focusNode2,
                            ),
                          ],
                        ),
                      )),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //  color: Colors.red,
                    child: ImageInput(setimage),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 170,
                          // color: Colors.black38,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child:Card
                          (

                            color: Colors.pink[300],
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text('Gender',style: TextStyle(color: Colors.white),)))),
                      Container(
                        //alignment: Alignment.center,
                        child: DropdownButton<String>(
                          value: gender, //initial selected value
                          onChanged: (selval) {
                            setState(() {
                              gender = selval;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          hint: Text('Select your gender'),
                          elevation: 9,

                          items: [
                            DropdownMenuItem(
                              child: Text('Male'),
                              value: 'male',
                            ),
                            DropdownMenuItem(
                              child: Text('Female'),
                              value: 'female',
                            ),
                            DropdownMenuItem(
                              child: Text('Others'),
                              value: 'others',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Profession')),
                      DropdownButton<String>(
                        value: profession,
                        onChanged: (val) {
                          setState(() {
                            profession = val;
                          });
                        },
                        elevation: 9,
                        hint: Text('Choose my profession'),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        items: professions.map((element) {
                          return DropdownMenuItem(
                            key: ValueKey(element),
                            child: Text(element),
                            value: element,
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 70,
                  ),

                  Container(
                    //alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        countryname != null
                            ? Container(
                                width: 150,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: FittedBox(child: Text(countryname)))
                            : Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text('Select your country'),
                              ),
                        ElevatedButton(
                            onPressed: () {
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: CountryListThemeData(
                                      textStyle:
                                          TextStyle(fontFamily: 'Roboto')),
                                  onSelect: (Country country) {
                                    setState(() {
                                      countryname = country.name;
                                    });
                                    //print(country.displayName);
                                  });
                            },
                            child: Text('Pick my country')),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  FloatingActionButton(
                    onPressed: saveform,
                    child: Icon(Icons.navigate_next),
                  )

                  //Text(countryname),
                ],
              ),
            ),
    );
  }
}
