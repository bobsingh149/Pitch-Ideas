import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pitch/helper/firebasequeries.dart';

class Contact {
  // String id;
  String userid;
  String name;
  String gender;
  int age;
  String profession;
  String country;
  String url;

  Contact(
      {
      //this.id,
      this.age,
      this.country,
      this.gender,
      this.userid,
      this.name,
      this.profession,
      this.url});
}

class Contactsdata with ChangeNotifier {
  List<Contact> _mycontacts = [];
  List<Contact> _invcontacts = [];
  List<Contact> _myinvestment = [];
  Map<String, bool> teamuptrack = {};
  Map<String, bool> investtrack = {};

  List<Contact> get contacts {
    return [..._mycontacts];
  }

  List<Contact> get invcontacts {
    return [..._invcontacts];
  }

  List<Contact> get myinvestment {
    return [..._myinvestment];
  }

  Future<void> teamup({String ideaid, String otherpersonid}) async {
    //if(_mycontacts.contains(element))
    if (teamuptrack.containsKey(otherpersonid)) return;

   await incscore(ideaid);

    print('working');
    await FirebaseHelper.add(
        collectionpath: 'users/$otherpersonid/contacts',
        data: {
          'uid': FirebaseHelper.getid(),
        });

    await FirebaseHelper.add(
        collectionpath: 'users/${FirebaseHelper.getid()}/contacts',
        data: {
          'uid': otherpersonid,
        });

    final userinfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherpersonid)
        .get();

    print('usermap :${userinfo.data()}');

    if (userinfo.data() == null) return;

    Contact contact = new Contact(
      age: userinfo['age'],
      country: userinfo['country'],
      gender: userinfo['gender'],
      userid: otherpersonid,
      name: userinfo['name'],
      profession: userinfo['profession'],
      url: userinfo['url'],
    );
    teamuptrack[otherpersonid] = true;
    _mycontacts.add(contact);
    notifyListeners();
  }

  Future<void> getinvcontacts(String ideaid) async {
    if (_invcontacts.isNotEmpty) return;

    _invcontacts.clear();
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection('ideas/$ideaid/investor')
          //.where('blocked', isEqualTo: false)
          .get();

      final contactlist = snapshots.docs;

      print('contactlist ${contactlist.length}');

      for (int i = 0; i < contactlist.length; i++) {
        //  if (i == 1||i==3) continue;
        String userid = contactlist[i]['uid'];
        userid = userid.trim();
        print('userid$userid');
        /* userinfo = await FirebaseHelper.getitem(
            collectionpath: 'users', itemid: userid);*/

        final userinfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();

        print('usermap :${userinfo.data()}');

        if (userinfo.data() == null) continue;

        Contact contact = new Contact(
          age: userinfo['age'],
          country: userinfo['country'],
          gender: userinfo['gender'],
          userid: contactlist[i]['uid'],
          name: userinfo['name'],
          profession: userinfo['profession'],
          url: userinfo['url'],
        );
        /* print(contact.age);
        print(contact.country);
        print(contact.gender);
        print(contact.name);
        print(contact.profession);
         print(contact.userid);*/

        _invcontacts.add(contact);
      }

      //notifyListeners();
      print('completed');
    } catch (error) {
      throw error;
    }
  }

  Future<void> getMyInvestment({bool refresh = false}) async {
    if (!refresh) {
      if (_mycontacts.isNotEmpty) return;
    }
    _myinvestment.clear();
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection('users/${FirebaseHelper.getid()}/myinvestments')
          //.where('blocked', isEqualTo: false)
          .get();

      final contactlist = snapshots.docs;

      print('contactlist ${contactlist.length}');

      for (int i = 0; i < contactlist.length; i++) {
        String userid = contactlist[i]['uid'];
        // userid = userid.trim();
        print('userid$userid');
        /* userinfo = await FirebaseHelper.getitem(
            collectionpath: 'users', itemid: userid);*/

        final userinfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();
        print(userinfo);
        print('usermap :${userinfo.data()}');

        if (userinfo.data() == null) continue;

        Contact contact = new Contact(
          age: userinfo['age'],
          country: userinfo['country'],
          gender: userinfo['gender'],
          userid: contactlist[i]['uid'],
          name: userinfo['name'],
          profession: userinfo['profession'],
          url: userinfo['url'],
        );
        print(contact.age);
        print(contact.country);
        print(contact.gender);
        print(contact.name);
        print(contact.profession);
        // print(contact.userid);
        investtrack[userid] = true;
        _myinvestment.add(contact);
      }

      // notifyListeners();
      print('completed');
    } catch (error) {
      print('error');
      throw error;
    }
  }

  Future<void> incscore(String ideaid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('ideas').doc(ideaid).get();
    int score = snapshot.get('score');

    print('score $score');

    await FirebaseFirestore.instance.collection('ideas').doc(ideaid).update({
      'score': score + 1,
    });
  }

  Future<void> invest(String ideaid, String ideaowner) async {
    if (investtrack.containsKey(ideaid)) return;

    await incscore(ideaid);

    await FirebaseHelper.add(collectionpath: 'ideas/$ideaid/investor', data: {
      'uid': FirebaseHelper.getid(),
    });
    FirebaseFirestore.instance
        .collection('users/${FirebaseHelper.getid()}/myinvestments')
        .add({'ideaid': ideaid, 'owner': ideaowner});

    investtrack[ideaid] = true;
  }

  Future<void> getcontacts(bool refresh) async {
    if (!refresh) {
      if (_mycontacts.isNotEmpty) return;
    }
    _mycontacts.clear();
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection('users/${FirebaseHelper.getid()}/contacts')
          //.where('blocked', isEqualTo: false)
          .get();

      final contactlist = snapshots.docs;

      print('contactlist ${contactlist.length}');

      for (int i = 0; i < contactlist.length; i++) {
        String userid = contactlist[i]['uid'];
        // userid = userid.trim();
        print('userid$userid');
        /* userinfo = await FirebaseHelper.getitem(
            collectionpath: 'users', itemid: userid);*/

        final userinfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();
        print(userinfo);
        print('usermap :${userinfo.data()}');

        if (userinfo.data() == null) continue;

        Contact contact = new Contact(
          age: userinfo['age'],
          country: userinfo['country'],
          gender: userinfo['gender'],
          userid: contactlist[i]['uid'],
          name: userinfo['name'],
          profession: userinfo['profession'],
          url: userinfo['url'],
        );
        print(contact.age);
        print(contact.country);
        print(contact.gender);
        print(contact.name);
        print(contact.profession);
        // print(contact.userid);
        teamuptrack[userid] = true;
        _mycontacts.add(contact);
      }

      // notifyListeners();
      print('completed');
    } catch (error) {
      print('error');
      throw error;
    }
  }

  Future<void> sendMessage(String recieverid, String message) async {
    final String myid = FirebaseHelper.getid();
    int cmp = myid.compareTo(recieverid);
    final String doccid =
        cmp > 0 ? myid + ' ' + recieverid : recieverid + ' ' + myid;

    await FirebaseHelper.add(collectionpath: 'allchats/$doccid/chats', data: {
      'message': message,
      'sender': FirebaseHelper.getid(),
      'time': Timestamp.now(),
    });

    /*  FirebaseFirestore.instance
        .collection('users/${FirebaseHelper.getid()}/chats')
        .where('sender',isEqualTo:'kghgjktn')
        .snapshots();*/
  }

  void clear() {
    _mycontacts.clear();
    _invcontacts.clear();
  }
}
