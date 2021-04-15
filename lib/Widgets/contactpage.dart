import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';

class ContactPage extends StatefulWidget {
  static const String routename = '/contactpage';
  // ContactPage({this.contactid, this.name});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String name;
  String contactid;
  String myid = FirebaseHelper.getid();
  String docid;
  TextEditingController message = TextEditingController();
  Future<void> sendtext(Contactsdata contactsdata) async {
    if (message.text.trim().isEmpty) return;

    FocusScope.of(context).unfocus();

    await contactsdata.sendMessage(contactid, message.text);

    message.text = '';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('text send '),
      action: SnackBarAction(
        label: 'undo',
        onPressed: null,
      ),
    ));
  }

  bool itsmymessage(String senderid) {
    if (FirebaseHelper.getid() == senderid)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    name = args['name'];
    contactid = args['id'];
    int cmp = myid.compareTo(contactid);
    if (cmp > 0)
      docid = myid + ' ' + contactid;
    else
      docid = contactid + ' ' + myid;

    Contactsdata contactsdata = Provider.of<Contactsdata>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.8,
                //color: Colors.amber,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('allchats/$docid/chats')
                        .orderBy('time', descending: true)
                        //.where('sender',
                        //isEqualTo:FirebaseHelper.getid())

                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (ctx, idx) {
                            return Container(
                              alignment:itsmymessage(snapshot.data.docs[idx]['sender'])
                               ?Alignment.centerRight 
                               :Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:MediaQuery.of(context).size.width*0.7,
                                     // color:itsmymessage(snapshot.data.docs[idx]['sender']) ?Colors.lightGreen
                                      //:Colors.amber,
                                      // alignment: Alignment.center,
                                      padding: EdgeInsets.all(7),
                                      child: Bubble(
                                        margin: BubbleEdges.only(top: 10),
  radius: Radius.zero,
  alignment:itsmymessage(snapshot.data.docs[idx]['sender']) ?Alignment.topRight  :Alignment.topLeft,
  nipWidth: 8,
  nipHeight: 24,
  nip: BubbleNip.rightTop,
  color:itsmymessage(snapshot.data.docs[idx]['sender'])  ?Color.fromRGBO(225, 255, 199, 1.0)
  :Colors.white70,

                                        /*color:itsmymessage(snapshot.data.docs[idx]['sender']) ?Colors.lightGreen
                                      :Colors.amber*/ 
                                        child: Text(
                                            snapshot.data.docs[idx]['message'],
                                            style: TextStyle(color: Colors.black,fontFamily: 'Roboto',fontSize: 15)),
                                      )),
                                  SizedBox(height: 15),
                                ],
                              ),
                            );
                          });
                    }),
              ),
              /* Container(
                height: 300,
               // alignment: Alignment.bottomRight,
               // color: Colors.amber,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users/${FirebaseHelper.getid()}/chats')
                        .where('sender',isEqualTo:contactid)
                        //.orderBy('time',descending: true)
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (ctx, idx) {
                            return Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Container(
                                    color: Colors.yellow,
                                    padding: EdgeInsets.all(7),
                                  //  alignment: Alignment.bottomRight,
                                    child: Text(snapshot.data.docs[idx]['message'],
                                    style: TextStyle(color: Colors.black),),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            );
                          });
                    }),
              ),*/

              
              Container(
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 300,
                      child: TextField(
                        decoration:
                            InputDecoration(labelText: 'Start typing text'),
                        controller: message,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.green,
                        onPressed: () {
                          sendtext(contactsdata);
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
