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
  Map<String, List<Contact>> invcontacts = {};
  List<Contact> _myinvestment = [];
  Map<String, bool> teamuptrack = {};
  Map<String, bool> investtrack = {};
  String myid = FirebaseHelper.getid();
  String myname;
  bool namefetched = false;
  List<Contact> get contacts {
    return [..._mycontacts];
  }

  List<Contact> get myinvestment {
    return [..._myinvestment];
  }

  Future<void> inboxteam({@required Contact c}) async {
    if (!namefetched) {
 
      this.myname = await FirebaseHelper.getitemfield(
          collectionpath: 'users', itemid: this.myid, field: 'name');
     print(myname);
      namefetched = true;
    }
    FirebaseFirestore.instance.collection('users/${c.userid}/inbox').add({
      'm':
          '${this.myname} has requested a team up with you, find him/her in your team contacts'
    });
  }

  Future<void> inboxinvest(
      {@required Contact c, @required String ideatitle}) async {
    if (!namefetched) {
      this.myname = await FirebaseHelper.getitemfield(
          collectionpath: 'users', itemid: this.myid, field: 'name');
      namefetched = true;

           print(myname);
    }
    FirebaseFirestore.instance.collection('users/${c.userid}/inbox').add({
      'm':
          '${this.myname} will like to invest in your $ideatitle idea, to connect with him/her go to your idea in \"MyIdeas\" tab and tap on \"see investors\"'
    });
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

    //print('usermap :${userinfo.data()}');

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
    await this.inboxteam(c: contact);
    notifyListeners();
  }

  Future<void> getinvcontacts(String ideaid) async {
    if (invcontacts.containsKey(ideaid)) return;

    Map<String, bool> invmap = {};
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection('ideas/$ideaid/investor')
          //.where('blocked', isEqualTo: false)
          .get();

      invcontacts[ideaid] = [];

      final contactlist = snapshots.docs;

      //  print('contactlist ${contactlist.length}');

      for (int i = 0; i < contactlist.length; i++) {
        //  if (i == 1||i==3) continue;

        String userid = contactlist[i]['uid'];
        if (invmap.containsKey(userid)) continue;
        userid = userid.trim();
        // print('userid$userid');
        /* userinfo = await FirebaseHelper.getitem(
            collectionpath: 'users', itemid: userid);*/

        final userinfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();

        // print('usermap :${userinfo.data()}');

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

        invcontacts[ideaid].add(contact);
        invmap[userid] = true;
      }

      //notifyListeners();
      //print('completed');
    } catch (error) {
      throw error;
    }
  }

  Future<void> getMyInvestment() async {
    if (_myinvestment.isNotEmpty) return;

    _myinvestment.clear();

    Map<String, bool> myinvmap = {};
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection('users/${FirebaseHelper.getid()}/myinvestments')
          //.where('blocked', isEqualTo: false)
          .get();

      final contactlist = snapshots.docs;

      //print('contactlist ${contactlist.length}');

      for (int i = 0; i < contactlist.length; i++) {
        String userid = contactlist[i]['owner'];
        //print('reached $userid');
        if (myinvmap.containsKey(userid)) continue;
        // userid = userid.trim();
        //print('userid$userid');
        /* userinfo = await FirebaseHelper.getitem(
            collectionpath: 'users', itemid: userid);*/

        final userinfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();
        // print(userinfo);
        //print('usermap :${userinfo.data()}');

        if (userinfo.data() == null) continue;

        Contact contact = new Contact(
          age: userinfo['age'],
          country: userinfo['country'],
          gender: userinfo['gender'],
          userid: userid,
          name: userinfo['name'],
          profession: userinfo['profession'],
          url: userinfo['url'],
        );
        // print(contact.age);
        //print(contact.country);
        //print(contact.gender);
        // print(contact.name);
        // print(contact.profession);
        // print(contact.userid);
        investtrack[userid] = true;
        _myinvestment.add(contact);
        myinvmap[userid] = true;
      }
      // print('done');
      // notifyListeners();
      //print('completed');
    } catch (error) {
      //print('error');
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

  Future<void> invest(
      {String ideaid, String ideaowner, String ideatitle}) async {
    if (investtrack.containsKey(ideaowner)) return;

    await incscore(ideaid);

    await FirebaseHelper.add(collectionpath: 'ideas/$ideaid/investor', data: {
      'uid': FirebaseHelper.getid(),
    });
    FirebaseFirestore.instance
        .collection('users/${FirebaseHelper.getid()}/myinvestments')
        .add({'ideaid': ideaid, 'owner': ideaowner});

    final userinfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(ideaowner)
        .get();

    //print('usermap :${userinfo.data()}');

    if (userinfo.data() == null) return;

    Contact contact = new Contact(
      age: userinfo['age'],
      country: userinfo['country'],
      gender: userinfo['gender'],
      userid: ideaowner,
      name: userinfo['name'],
      profession: userinfo['profession'],
      url: userinfo['url'],
    );
    investtrack[ideaowner] = true;
    _myinvestment.add(contact);
    await this.inboxinvest(c: contact, ideatitle: ideatitle);
    notifyListeners();

    // notifyListeners();
  }

  Future<void> getcontacts() async {
    if (_mycontacts.isNotEmpty) return;

    _mycontacts.clear();
    Map<String, bool> mycontactsmap = {};
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection('users/${FirebaseHelper.getid()}/contacts')
          //.where('blocked', isEqualTo: false)
          .get();

      final contactlist = snapshots.docs;

      //  print('contactlist ${contactlist.length}');

      for (int i = 0; i < contactlist.length; i++) {
        String userid = contactlist[i]['uid'];

        if (mycontactsmap.containsKey(userid)) continue;
        // userid = userid.trim();
        //print('userid$userid');
        /* userinfo = await FirebaseHelper.getitem(
            collectionpath: 'users', itemid: userid);*/

        final userinfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();
        //print(userinfo);
        //print('usermap :${userinfo.data()}');

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
        //print(contact.age);
        //print(contact.country);
        // print(contact.gender);
        //print(contact.name);
        //print(contact.profession);
        // print(contact.userid);
        teamuptrack[userid] = true;
        _mycontacts.add(contact);
        mycontactsmap[userid] = true;
      }

      // notifyListeners();
      //print('completed');
    } catch (error) {
      //print('error');
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
    invcontacts.clear();
    _myinvestment.clear();
    teamuptrack.clear();
    investtrack.clear();
  }
}
