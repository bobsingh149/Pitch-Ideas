import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/Screens/waiting.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:pitch/Widgets/myideasitem.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class ShowMyIdeas extends StatefulWidget {
  static const routename = '/myideas';
  @override
  _ShowMyIdeasState createState() => _ShowMyIdeasState();
}

class _ShowMyIdeasState extends State<ShowMyIdeas> {
  bool init = true;
  bool isloading = false;
  UserIdeas userideas;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      userideas = Provider.of<UserIdeas>(context, listen: true);

      setState(() {
        isloading = true;
      });

      userideas.initilize().then((value) {
        setState(() {
          isloading = false;
        });
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //print(FirebaseHelper.getid());
    // print(userideas.myIdeas.length);
    return Container(
      /* appBar: AppBar(
        title: Text('MY Ideas'),
      ),
       drawer: Drawers(),*/
      child: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : /*StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ideas')
                  .where('uid', isEqualTo: FirebaseHelper.getid())
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  print('data  ${userideas.myideas}');*/
          ListView.builder(
              itemCount: userideas.myIdeas.length,
              itemBuilder: (ctx, idx) {
                final myideas = userideas.myIdeas;
                return
                    // Text(userideas.myIdeas[idx].title);
                    MyIdeasItem(
                  id: myideas[idx].id,
                  title: myideas[idx].title,
                  about: myideas[idx].about,
                );
              }),
    );
  }
}
