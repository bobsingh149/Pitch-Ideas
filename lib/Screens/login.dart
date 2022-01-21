//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:pitch/Providers/authorize.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Providers/logindata.dart';
import 'package:pitch/Screens/homeScreen.dart';
import 'package:pitch/Screens/myideas.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

enum authtype {
  signup,
  signin,
}

class Login extends StatefulWidget {
  static const routename = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // var credential;
  bool isloading = false;
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  int len = 0;
  /* Future<void> onsub(
      {String username, String password, Auth data, authtype type}) async {
    print('username: $username');

    if (type == authtype.signup) {
      try {
        setState(() {
          isloading = true;
        });
        await data.signup(username, password);

        setState(() {
          isloading = false;
        });

        //Navigator.of(context).pushReplacementNamed(HomeScreen.routename);
      } catch (error) {
        print(error.toString());
        /*bool reply = await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error occured'),
                content: Text('Sorry we couldn\'t sign you up'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ok'))
                ],
              );
            });

        if (reply == true) {
          setState(() {
            isloading = false;
          });*/

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occured')));

        print('isloading $isloading');
        setState(() {
          isloading = false;
        });
      }
    } else {
      try {
        setState(() {
          isloading = true;
        });
        await data.signin(username, password);
        setState(() {
          isloading = false;
        });
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routename);
      } catch (error) {
        /* bool reply = await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error occured'),
                content: Text('Sorry we couldn\'t log you in'),
                actions: [
                  ElevatedButton(
                      key: ValueKey('IconButton'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ok'))
                ],
              );
            });*/

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occured')));

        print('isloading $isloading');
        setState(() {
          isloading = false;
        });
      }
    }

    /*if (data.authorize(username, password)) {
      Navigator.of(context).pushNamed(HomeScreen.routename);
      /*showModalBottomSheet(
          context: context,
          builder: (_) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              color: Colors.yellow,
              child: FittedBox(fit: BoxFit.fitWidth, child: Center(child: Text(username))),
            );
          });*/

    } else {
      showDialog(
          context: context,
          builder: (_) => Container(
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.all(25),
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  child: Text('Invalid Username or Password',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ));
    }

    //data.add(username, password);
    // print(data.length);*/
  }*/

  Future<void> authenticate(
      String email, String password, authtype mode) async {
    FirebaseAuth fireauth = FirebaseAuth.instance;
    if (mode == authtype.signup) {
      try {
        setState(() {
          isloading = true;
        });

        Provider.of<Global>(context, listen: false).setuser(true);

        final usercredential = await fireauth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Provider.of<Global>(context).setuser(credential.additionalUserInfo.isNewUser);
      } catch (error) {
        //print(error.runtimeType);
        final e = error.toString();
        //print(e.runtimeType);
        if (e.contains('formatted')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Invalid Email Address')));
        } else if (e.contains('empty')) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email or pasword can\'t be empty')));
        } else if (e.contains('network')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No Internet Connection')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e)));
        }
        //else if(e.contains('other'))
        //print(e);
        setState(() {
          isloading = false;
        });
      } finally {}
    } else {
      try {
        setState(() {
          isloading = true;
        });

        await fireauth.signInWithEmailAndPassword(
            email: email, password: password);

        //Provider.of<Global>(context).setuser(credential.additionalUserInfo.isNewUser);
      } catch (error) {
        final e = error.toString();
        if (e.contains('formatted')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Invalid Email Address')));
        } else if (e.contains('empty')) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email or pasword can\'t be empty')));
        } else if (e.contains('network')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No Internet Connection')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e)));
        }

       // print(error);
        setState(() {
          isloading = false;
        });
      } finally {}

      //print(credential.user);
    }
  }

  void unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    /* var data = Provider.of<Auth>(
      context,
    );*/
    final mediaquery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login or Sign up to continue',
          style: TextStyle(color: theme.accentColor),
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: AssetImage('assets/login.jpg'),
                      fit: BoxFit.cover,
                    ),
                    gradient: LinearGradient(colors: [
                      Colors.teal,
                      Colors.deepOrange,
                      Colors.amber,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                ),
                Container(
                  height: mediaquery.size.height * 0.7,
                  width: mediaquery.size.width * 0.76,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Pitch Your Ideas',
                          style: theme.textTheme.headline1,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: mediaquery.size.height * 0.55,
                          width: mediaquery.size.width * 0.76,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(150, 170, 100, 0.87),
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  fillColor: Colors.amber,
                                  hintText: 'Enter your username',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                                controller: username,
                                //onSubmitted: (_) {
                                //print(username.text);
                                //},
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  fillColor: Colors.amber,
                                  hintText: 'Enter your password',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                                obscureText: true,
                                controller: password,
                                //onSubmitted: onsub,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () => authenticate(
                                          username.text.trim(),
                                          password.text.trim(),
                                          authtype.signup),
                                      child: Text(
                                        'SignUp',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                      onPressed: () => authenticate(
                                          username.text.trim(),
                                          password.text.trim(),
                                          authtype.signin),
                                      child: Text(
                                        'Signin',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              //FloatingActionButton(onPressed: () => widget.set('changed')),
                              Container(
                                color: Colors.amber,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    setState(() {
                                      isloading = true;
                                    });

                                    try {
                                      final user =
                                          await GoogleSignIn().signIn();
                                      //print(user.displayName);
                                      //print(user.email);
                                      //print(user.id);

                                      if (user == null) {
                                        setState(() {
                                          isloading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('An error occured')));
                                        return;
                                      }

                                      final authdata =
                                          await user.authentication;

                                      final credentials =
                                          GoogleAuthProvider.credential(
                                              accessToken: authdata.accessToken,
                                              idToken: authdata.idToken);

                                      final usercredential = await FirebaseAuth
                                          .instance
                                          .signInWithCredential(credentials);
                                      print(usercredential.toString());

                                      Provider.of<Global>(context,
                                              listen: false)
                                          .setuser(usercredential
                                              .additionalUserInfo.isNewUser);
                                    } catch (error) {
                                      final e = error.toString();
                                      setState(() {
                                        isloading = false;
                                      });
                                      if (error
                                          .toString()
                                          .contains('network_error')) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('No Internet Connection')));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(e)));
                                      }
                                    }
                                  },
                                  icon: FaIcon(FontAwesomeIcons.google),
                                  label: Text('Sign in with google account'),

                                  //style: ButtonStyle(shape: ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
