/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/category.dart';
import 'package:pitch/Screens/myideas.dart';
import 'package:pitch/Screens/pitch.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  static const routename = '/settings';

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<void> getideas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ideas')
          
          .where('private', isEqualTo: false)
          .where('uid', isNotEqualTo: FirebaseHelper.getid())
          .where('catid', isEqualTo: '3').where('score',isNotEqualTo:  -1)
          .orderBy('score', descending: true)
          .limit(1000)
          .get();

      print(snapshot.size);

      snapshot.docs.forEach((element) {
        print(element['title']);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> category() async {
    final catslist = Provider.of<CategoryData>(context, listen: false).category;

    for (int i = 0; i < catslist.length; i++) {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(catslist[i].id)
          .set({
        'id': catslist[i].id,
        'title': catslist[i].title,
        'url': catslist[i].url,
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          FloatingActionButton(onPressed: () {
            getideas();
          }),
        ],
      ),
      drawer: Drawers(),
      body: Wrap(
        direction: Axis.horizontal,
        children: [
          ElevatedButton(
              onPressed: null, child: Text('I am a button press me')),
          ElevatedButton(
              onPressed: null, child: Text('I am a button press me')),
          OutlinedButton(onPressed: null, child: Text('outlined')),
          ElevatedButton(
              onPressed: null, child: Text('I am a button press me')),
          ElevatedButton(
              onPressed: null, child: Text('I am a button press me')),
          OutlinedButton(onPressed: null, child: Text('outlined'))
        ],
      ),

      /*Container(
        color: Colors.amber,
        height: 700,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(onPressed: getideas),
            Container(
              height: 300,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            ),
            /*Spacer(
              flex: 1,
            ),*/
            Row(
              children: [
                Container(
                  height: 100,
                  color: Colors.green,
                ),
                Container(height: 100, color: Colors.brown),
              ],
            ),
            
          ],
        ),
      ),*/
    );
  }
}*/
