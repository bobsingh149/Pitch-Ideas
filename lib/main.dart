import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pitch/Providers/authorize.dart';
import 'package:pitch/Providers/category.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/Providers/imagedata.dart';
import 'package:pitch/Providers/logindata.dart';
import 'package:pitch/Screens/AllIdeasScreen.dart';
import 'package:pitch/Screens/Contacts.dart';
import 'package:pitch/Screens/Feedback.dart';
import 'package:pitch/Screens/FirstScreen.dart';

import 'package:pitch/Screens/Myimages.dart';
import 'package:pitch/Screens/ShowMyIdeas.dart';
import 'package:pitch/Screens/TabScreen.dart';
import 'package:pitch/Screens/additionalinfo.dart';
import 'package:pitch/Screens/allIdeas.dart';
import 'package:pitch/Screens/firebase.dart';
import 'package:pitch/Screens/homeScreen.dart';
import 'package:pitch/Screens/login.dart';
import 'package:pitch/Screens/pitch.dart';
import 'package:pitch/Screens/settings.dart';
import 'package:pitch/Screens/target.dart';
import 'package:pitch/Screens/userInput.dart';
import 'package:pitch/Screens/myideas.dart';
import 'package:pitch/Screens/waiting.dart';
import 'package:pitch/Widgets/contactpage.dart';
import 'package:pitch/Widgets/imageinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//maps just have named indexes insted of numbers

//Await and .then are only yo tell which code should
//execte after future has resolved and given value
//by default everything runs before it

//Give an idea of target audience like agegrouop,gender,profession,country,region
//Look for the multiple verified investors
//similar passion people can send request for team up
//give feedback on other ideas
//Upload collage of ideas to help you select the best one
//use map for showing country percentage
//use priority queue if reqiured
//store likes in ideas and order by it
//use limit to get some of the data
//use where and get for query

//Use gridtile
//Use linear gradient
//Add dismissile widget
//pull to refresh
//download the fonts
//store categoty images on storage
//initstate and change dependices very important
void main() {
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  return runApp(MyApp());
}

//Mainaxissize
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String isnewuser = 'initial';

  void set(newval) {
    isnewuser = newval;
  }

  String getdata() {
    return isnewuser;
  }

  Future<void> setfav(bool isfav) async {
    final shared = await SharedPreferences.getInstance();

    shared.setString('userdata', jsonEncode({'fav': isfav}));
  }

  bool fav() {
    SharedPreferences.getInstance().then((shared) {
      final datamap = jsonDecode(shared.getString('userdata'));
      return datamap['fav'];
    });

    return false;
  }

/*  Widget authenticate(Auth auth) {
    if (auth.isauth) {
      return HomeScreen();
    } else {
      return FutureBuilder(
        future: auth.autologin(),
        builder: (ctx, snapshot) {
          //When future is building it manages it and function returns
          //Waiting till then home has Loading screen
          //once it is done it returns our main widget

          //If you don't do this then
          //we will render login staright away
          //but future will take some time so use waiting till then
          if (snapshot.connectionState == ConnectionState.waiting)
            return Waiting();
          else {
            /*if (snapshot.data ==true)
              return HomeScreen();
            else*/
            return Login();
          }
        },
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    //if(MediaQuery.of(context).orientation==Orientation.landscape)
    //final bottom = MediaQuery.of(context).viewInsets.bottom;
    /*if(Platform.isIOS)
    {

    }*/
    //It is just a function you can have local variables

    //Builder returns new widget like showdatepicker
    final initapp = Firebase.initializeApp();

    return FutureBuilder(
        future: initapp,
        builder: (ctx, app) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Auth()),
              ChangeNotifierProvider(
                create: (_) => LoginData(), //creates a object
              ),
              ChangeNotifierProvider(create: (_) {
                return CategoryData();
              }),
              ChangeNotifierProvider(create: (_) => Global()),
              ChangeNotifierProvider(create: (_) => ImageData()),
              ChangeNotifierProvider(create: (_) => UserIdeas()),
              ChangeNotifierProvider(create: (_) => Contactsdata()),
            ],
            child: Consumer<Global>(
              builder: (context, global, wid) => MaterialApp(
                title: 'Pitch',

                theme: ThemeData(
                  primarySwatch: Colors.deepPurple,
                  accentColor:Colors.amber,
                  //Color.fromRGBO(255, 215, 0, 1),
                  //scaffoldBackgroundColor:Colors.amberAccent,

                  textTheme: TextTheme(
                    subtitle1: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        color: Colors.black),
                         subtitle2: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        color: Colors.white),
                    bodyText1: TextStyle(
                        //fontFamily: 'alt',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                    headline1: TextStyle(
                      //unmaamed objects can call methods using .()
                      color:
                          //Colors.deepPurple,
                          Color.fromRGBO(255, 215, 0, 1),

                      fontSize: 37,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'alt',
                      //height: 1.5,
                    ),
                    headline2: TextStyle(
                      //unmaamed objects can call methods using .()
                      //color: Color.fromRGBO(255, 215, 0, 1),
                      color: Colors.white,

                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      // fontFamily: 'Roboto',
                      //height: 1.5,
                    ),
                    headline3: TextStyle(color: Colors.black,fontWeight: FontWeight.w800, fontSize: 26),
                    bodyText2: TextStyle(
                      color:
                          //Colors.black,
                          //Color.fromRGBO(170, 90, 160, 0.9),
                          Colors.pink[300],
                      fontSize: 20,
                      fontWeight: FontWeight.w700,

                      fontFamily: 'Roboto',
                      // height: 2.5,
                    ),
                  ),
                  // brightness: Brightness.dark,
                ),
                //It'snapshot like set state only because we are using provider
                home: app.connectionState == ConnectionState.waiting
                    ? Waiting()
                    : First(),
                routes: {

                  
                  
                  HomeScreen.routename: (ctx) => HomeScreen(),
                  Pitch.routename: (ctx) => Pitch(),
                  Setting.routename: (ctx) => Setting(),
                  UserInput.routename: (ctx) => UserInput(),
                  // MyIdeas.routename: (ctx) => MyIdeas(),
                  MyImages.routename: (ctx) => MyImages(),
                  //ImageInput.routename: (ctx) => ImageInput(),
                  // AllIdeas.routename: (ctx) => AllIdeas(),
                  Target.routename: (ctx) => Target(),
                  ContactPage.routename: (ctx) => ContactPage(),
                  Tabs.routename: (ctx) => Tabs(),
                  ContactScreen.routname: (ctx) => ContactScreen(),
                  ShowMyIdeas.routename: (ctx) => ShowMyIdeas(),
                  MyFeedback.routename: (ctx) => MyFeedback(),
                  Login.routename: (ctx) => Login(),
                  Additional.routename: (ctx) => Additional(),
                  AllIdeasScreen.routename: (ctx) => AllIdeasScreen(),
                  First.routename:(ctx)=>First(),
                },
              ),
            ),
          );
        });
  }
}
