import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pitch/Screens/userInput.dart';
import 'package:pitch/Widgets/allideasitem.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:pitch/helper/firebasequeries.dart';

class AllIdeas extends StatefulWidget {
  static const String routename = 'allideas';

  @override
  _AllIdeasState createState() => _AllIdeasState();
}

class _AllIdeasState extends State<AllIdeas> {
  int filtervalue = 0;
  @override
  Widget build(BuildContext context) {

    return
       Container(
          // height: 500,

          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.pink[300],
                child: DropdownButton<int>(
                    value: filtervalue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    hint: Text('Filters'),
                    elevation: 9,
                    onChanged: (val) {
                      setState(() {
                        filtervalue = val;
                      });
                    },
                    items: [
                      DropdownMenuItem(child: Text('Show All'), value: 0),
                      DropdownMenuItem(child: Text('only stratups'), value: 1),
                      DropdownMenuItem(child: Text('only Novels'), value: 2),
                      DropdownMenuItem(
                          child: Text('only Scrrenplays'), value: 3),
                      DropdownMenuItem(child: Text('only Projects'), value: 4),
                      DropdownMenuItem(child: Text('only Art'), value: 5),
                      DropdownMenuItem(
                          child: Text('only Technology'), value: 6),
                      DropdownMenuItem(
                          child: Text('only Science Theories'), value: 7),
                    ]),
              ),
              SizedBox(height: 15,),
              Container(
               // color: Colors.red,
                  height: 700,
                  // color: Colors.amber,
                  /* appBar: AppBar(
                      title: const Text('Browse All Ideas'),
                      actions: [
                        FloatingActionButton(onPressed: () {
                          Navigator.of(context).pushNamed(UserInput.routename);
                        })
                      ],
                    ),
                    drawer: Drawers(),*/
                  child: StreamBuilder(
                    stream: filtervalue == 0
                        ? FirebaseFirestore.instance
                            .collection('ideas')
                            .where('private', isEqualTo: false)
                            //.where('uid',isNotEqualTo: FirebaseHelper.getid())
                            .orderBy('score', descending: true)
                            .limit(1000)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('ideas')
                            .where('private', isEqualTo: false)
                            //.where('uid',isNotEqualTo: FirebaseHelper.getid())
                            .where('catid', isEqualTo: filtervalue.toString())
                            .orderBy('score', descending: true)
                            .limit(1000)
                            .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());

                      return Container(
                          // height: 300,
                          //color: Colors.amber,
                          // padding: EdgeInsets.all(30),
                          //  margin: EdgeInsets.only(left: 15),

                          child: snapshot.data.size == 0
                              ? Text('No such ideas be the first to post')
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.docs.length,
                                 // physics: BouncingScrollPhysics(),
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (ctx, idx) {
                                    if (snapshot.data.docs[idx]['uid'] !=
                                        FirebaseHelper.getid()) {
                                      return AllIdeasItem(
                                        title: snapshot.data.docs[idx]['title'],
                                        about: snapshot.data.docs[idx]['about'],
                                        id: snapshot.data.docs[idx].id,
                                        ideaowner: snapshot.data.docs[idx]
                                            ['uid'],
                                        cattitle: snapshot.data.docs[idx]
                                            ['cattilte'],
                                        description: snapshot.data.docs[idx]
                                            ['description'],
                                            invest:snapshot.data.docs[idx]
                                            ['investor'] ,
                                      );
                                    } else
                                      return SizedBox();
                                  }
                                  /* children: snapshot.data.docs.map((e) {
                              return AllIdeasItem(
                                id: e.id,
                                title: e['title'],
                              );
                            }).toList(),
                          ),*/
                                  ));
                    },
                  )),
            ],
          ),
        
      );
    
  }
}
