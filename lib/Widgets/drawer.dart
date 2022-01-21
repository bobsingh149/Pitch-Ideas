import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/authorize.dart';
import 'package:pitch/Providers/category.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/Screens/Contacts.dart';
import 'package:pitch/Screens/FirstScreen.dart';
import 'package:pitch/Screens/TabScreen.dart';
import 'package:pitch/Screens/homeScreen.dart';
import 'package:pitch/Screens/inbox.dart';
import 'package:pitch/Screens/login.dart';
import 'package:pitch/Screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawers extends StatelessWidget {
  Widget listtilebuilder(
      {String title, String sub, Icon icon, Function f, BuildContext ctx}) {
    return ListTile(
      
      title: Text(
        title,
        style: Theme.of(ctx).textTheme.bodyText2,
      ),
      subtitle: Text(
        sub,
        style: Theme.of(ctx).textTheme.subtitle1,
      ),
      trailing: icon,
      onTap: f,
    );
  }

  Widget build(BuildContext context) {
    //  final auth = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.white,
          Colors.white54,
          Colors.blue,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Container(

                //height: constraint.maxHeight,
                //width: constraint.maxWidth  ,
                height: 150,
                child: LayoutBuilder(
                  builder: (ctx, constraint) {
                    return Container(
                      // height: constraint.maxHeight*0.5,
                      child: DrawerHeader(
                        child: Text('Menu'),
                        decoration: BoxDecoration(color: Colors.cyan),
                      ),
                    );
                  },
                )),
            listtilebuilder(
              title: 'Home',
              sub: 'Go back to HomeScreen',
              f: () {
                Navigator.of(context).pushReplacementNamed(Tabs.routename);
              },
              icon: Icon(Icons.home),
              ctx: context,
            ),
            listtilebuilder(

              title: 'Team Contacts',
              sub: 'meet with your team',
              
              f: () {
                Navigator.of(context)
                    .pushReplacementNamed(ContactScreen.routname);
              },
              icon: Icon(Icons.contacts),
              ctx: context,
            ),
             listtilebuilder(
              title: 'My Investments',
              sub: 'See my investments',
              f: () {
                Navigator.of(context).pushReplacementNamed(ContactScreen.routname
                ,arguments: {'inv':false});
              },
              icon: Icon(Icons.monetization_on),
              ctx: context,
            ),
            listtilebuilder(
              title: 'Inbox',
              sub: 'See new notifications',
              f: () {
                Navigator.of(context).pushReplacementNamed(Inbox.routenamme);
              },
              icon: Icon(Icons.inbox),
              ctx: context,
            ),
            listtilebuilder(
              title: 'Logout',
              sub: 'Tap to logout',
              f: () async {
                Provider.of<UserIdeas>(context, listen: false).clear();
                Provider.of<Global>(context, listen: false).clear();
                // final shared = await SharedPreferences.getInstance();
                //shared.remove('userdata');
                Provider.of<CategoryData>(context, listen: false).clear();

                Provider.of<Contactsdata>(context, listen: false).clear();

                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    First.routename,
                   (route) => false
                  );

                });
              },
              icon: Icon(Icons.logout),
              ctx: context,
            ),
          ],
        ),
      ),
    );
  }
}
