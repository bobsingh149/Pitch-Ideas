import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:pitch/Providers/authorize.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:provider/provider.dart';

class StreamData extends StatefulWidget {
  final Function get;
  StreamData(this.get);
  @override
  _StreamDataState createState() => _StreamDataState();
}

class _StreamDataState extends State<StreamData> {
  File imagefile;
  String url;

  Future<void> pickimage() async {
    final picker = ImagePicker();
    final pickedfile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imagefile = File(pickedfile.path);
    });
  }

  int id = 0;
  @override
  Widget build(BuildContext context) {
    
    final global = Provider.of<Global>(context);
    //print('isnewuser :${Provider.of<Global>(context).isnewuser}');
    // final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream'),
        actions: [
          ElevatedButton.icon(
              onPressed: () async {
                if (imagefile == null) return;

                final res = await FirebaseStorage.instance
                    .ref('users/images/image1.jpg')
                    .putFile(imagefile);
//By doc you go to single item  use collection to get list

                /* setState(() {
                  url = res;
                });*/

                /*id++;
                final res = await FirebaseFirestore.instance
                    .collection('users/Q2YD3nY5MJ9Jcv7DyEbr/Info')
                    .doc('newidwillbevreated')
                    .get();
                print(res.data());*/
                /* 'name':'changed',
                      'error':'throw',
                      'new field':'added',
                    });*/
                //.delete();
                /*.add({
                  'name': 'Dummy',
                }*/

                /* FirebaseFirestore.instance
                    .collection('users')
                    .doc('user$id')
                    .set({
                  'userinfo': 'userid',
                  'age': 30,
                  'investor': true,
                });*/
              },
              icon: Icon(Icons.add),
              label: Text('add'))
        ],
      ),
      drawer: Drawers(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 300,
            width: 300,
            color: Colors.amber,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users/Q2YD3nY5MJ9Jcv7DyEbr/Info')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (ctx, idx) {
                    return Text(snapshot.data.docs[idx]['name']);
                  },
                );
              },
            ),
          ),
          Container(
            height: 200,
            color: Colors.green,
            child: imagefile == null
                ? Text('No Image Yet')
                : Image.file(
                    imagefile,
                    fit: BoxFit.contain,
                  ),
          ),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: pickimage),
          Text('isnewuser :${Provider.of<Global>(context).isnewuser}'),
         if(widget.get()!=null) Text(widget.get()),
          FloatingActionButton(onPressed: () {
            global.setuser(false);

            print(global.isnewuser);
          })
        ],
      ),
    );
  }
}
