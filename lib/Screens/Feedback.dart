import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:provider/provider.dart';

class MyFeedback extends StatefulWidget {
  static const routename = '/MyFeedback';

  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<MyFeedback> {
  bool isinit = true;
  //UserIdeas userIdeas;
  bool isloading = false;
  String ideaid;
  String title;
  bool nodata = false;
  @override
  void didChangeDependencies() {
    if (isinit) {
      final data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      ideaid = data['ideaid'];
      title = data['title'];
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ideas/$ideaid/feedback')
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
                        child: Text('No Feedbacks Yet'),
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
                                //color: Colors.white38,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                margin: EdgeInsets.all(5),
                                elevation: 9,
                                child: Padding(
                                    padding: EdgeInsets.all(19),
                                    child: Text(feedbacklist[idx]['feedback'],
                                        style: TextStyle(
                                            color: Colors.pink[300]))),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Text('No Feedbacks Yet',
                       style: TextStyle(
                                            color: Colors.pink[300])),
                    );
                  }
                }
              }),
    );
  }
}
