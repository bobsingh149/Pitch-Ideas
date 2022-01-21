import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:pitch/helper/firebasequeries.dart';

class Inbox extends StatefulWidget {
  static const routenamme = '/inbox';
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      drawer: Drawers(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/${FirebaseHelper.getid()}/inbox')
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              if (snap.hasData) {
                if (snap.data.docs.isEmpty) {
                  return Center(
                    child: Text('No Notifications Yet'),
                  );
                }
                final feedbacklist = snap.data.docs;
                return ListView.builder(
                    itemCount: feedbacklist.length,
                    itemBuilder: (ctx, idx) {
                      return ListTile(
                          title: Container(
                        padding: EdgeInsets.all(2),
                        child: Card(
                          //color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(5),
                          elevation: 9,
                          child: Padding(
                            padding: EdgeInsets.all(19),
                            child: Text(feedbacklist[idx]['m'],
                                style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )));
                    });
              } else {
                return Center(
                  child: Text('No Notifications Yet',
                      style: TextStyle(color: Colors.blue)),
                );
              }
            }
          }),
    );
  }
}
