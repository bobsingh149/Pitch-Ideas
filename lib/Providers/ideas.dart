import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pitch/Screens/myideas.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class Idea {
  String id;
  String title;
  String about;
  String description;
  //String img;
  bool investor;
  bool private;
  String catid;
  String cattitle;
  String uid;

  List<String> investorids = [];

  List<String> likesids = [];

  Idea({
    this.id,
    this.title = 'Default',
    this.about = 'Default',
    this.description = 'Default',
    // this.img = 'Default',
    this.investor = false,
    this.private = false,
    this.catid,
    @required this.uid,
    this.cattitle,
  });
}

class TargetData {
  Map<String, double> agegrp;
  Map<String, double> country;
  Map<String, double> gender;
  Map<String, double> profession;

  TargetData({this.agegrp, this.country, this.gender, this.profession});
}

class UserIdeas with ChangeNotifier {
  List<Idea> _myideas = [];

  Map<String, TargetData> ideastarget = {};

  Map<String, bool> likestrack = {};

  List<String> _feedbacks = [];
  int count = 0;
  List<Idea> get myIdeas {
    return [..._myideas];
  }

  List<String> get feedbacks {
    return [..._feedbacks];
  }

  Future<void> initilize({bool refresh = false}) async {
    if (!refresh) {
      if (_myideas.isNotEmpty) return;
    }

    _myideas.clear();

    QuerySnapshot snapshot;

    snapshot = await FirebaseFirestore.instance
        .collection('ideas')
        .where('uid', isEqualTo: FirebaseHelper.getid())
        .get();
    if (snapshot == null) return;
    print('done');

    final ideaslist = snapshot.docs;

    for (int i = 0; i < ideaslist.length; i++) {
      final ideadata = ideaslist[i].data();

      Idea idea = Idea(
          id: ideaslist[i].id,
          title: ideadata['title'],
          about: ideadata['about'],
          description: ideadata['description'],
          investor: ideadata['investor'],
          private: ideadata['private'],
          //img: ideadata['image'],
          uid: ideadata['uid'],
          catid: ideadata['catid'],
          cattitle: ideadata['cattitle']);

      idea.investorids = [];
      idea.likesids = [];

      final invlist = await FirebaseHelper.getlist(
          collectionpath: 'ideas/${idea.id}/investor');

      final likeslist = await FirebaseHelper.getlist(
          collectionpath: 'ideas/${idea.id}/likes');

      if (invlist == null) continue;

      for (int idx = 0; idx < invlist.length; idx++) {
        idea.investorids.add(invlist[idx]['uid']);
      }

      if (likeslist == null) continue;

      for (int idx = 0; idx < likeslist.length; idx++) {
        idea.likesids.add(likeslist[idx]['uid']);
      }

      _myideas.add(idea);
    }
    print('executed');
    notifyListeners();
  }

  Future<void> getfeedbacks(String ideaid) async {
    if (_feedbacks.isNotEmpty) return;
    final snaps = await FirebaseFirestore.instance
        .collection('ideas/$ideaid/feedback')
        .get();
    final feedbacklist = snaps.docs;

    feedbacklist.forEach((item) {
      _feedbacks.add(item['feedback']);
    });

    //notifyListeners();
  }

  Future<void> sendfeedback(String ideaid, String text) async {
    await FirebaseFirestore.instance.collection('ideas/$ideaid/feedback').add({
      'feedback': text,
      'sender': FirebaseHelper.getid(),
    });
  }

  void agegrp(datamap, agecount) {
    print('data map $datamap');
    print('age grp $agecount');

    if (datamap['age'] >= 0 && datamap['age'] <= 12) {
      agecount['1'] = agecount['1'] == null ? 1 : agecount['1'] + 1;
    } else if (datamap['age'] >= 13 && datamap['age'] <= 21) {
      agecount['2'] = agecount['2'] == null ? 1 : agecount['2'] + 1;
    } else if (datamap['age'] >= 22 && datamap['age'] <= 35) {
      agecount['3'] = agecount['3'] == null ? 1 : agecount['3'] + 1;
    } else if (datamap['age'] >= 36 && datamap['age'] <= 64) {
      agecount['4'] = agecount['4'] == null ? 1 : agecount['4'] + 1;
    } else {
      agecount['5'] = agecount['5'] == null ? 1 : agecount['5'] + 1;
    }
  }

  Future<TargetData> gettargetdata(String ideaid, bool refresh) async {
    if (!refresh) {
      if (ideastarget.containsKey(ideaid)) return ideastarget[ideaid];
    }

    print('entering');

    await initilize(refresh: true);
    TargetData targetdata =
        new TargetData(agegrp: {}, country: {}, gender: {}, profession: {});
    Idea idea = _myideas.firstWhere((element) => element.id == ideaid);
    final innovativeids = idea.likesids;
    print('liked ids ${idea.likesids}');

    if (innovativeids.isEmpty) return targetdata;
    print(innovativeids.length);
    Map<String, int> countrycount = {};
    Map<String, int> gendercount = {};

    Map<String, int> agecount = {};
    Map<String, int> professioncount = {};
    int totalinvestors = innovativeids.length;

    for (int idx = 0; idx < innovativeids.length; idx++) {
      final datamap = await FirebaseHelper.getitem(
          collectionpath: 'users', itemid: '${innovativeids[idx]}');
      if (datamap == null) continue;
      print(datamap);
      var str = 'country';
      print('county ${datamap[str]}');
      countrycount[datamap['country']] =
          countrycount[datamap['country']] == null
              ? 1
              : countrycount[datamap['country']] + 1;
      // print('done');
      gendercount[datamap['gender']] = gendercount[datamap['gender']] == null
          ? 1
          : gendercount[datamap['gender']] + 1;

      agegrp(datamap, agecount);

      professioncount[datamap['profession']] =
          professioncount[datamap['profession']] == null
              ? 1
              : professioncount[datamap['profession']] + 1;
    }
    /*gendercount.forEach((key, value) {
      print(key);
      print(value);
    });
    countrycount.forEach((key, value) {
      print(key);
      print(value);
    });
    professioncount.forEach((key, value) {
      print(key);
      print(value);
    });
    agecount.forEach((key, value) {
      print(key);
      print(value);
    });*/

    countrycount.forEach((key, value) {
      targetdata.country[key] =
          totalinvestors == 0 ? 0 : (value / totalinvestors) * 100;
    });
    gendercount.forEach((key, value) {
      targetdata.gender[key] =
          totalinvestors == 0 ? 0 : (value / totalinvestors) * 100;
    });
    agecount.forEach((key, value) {
      targetdata.agegrp[key] =
          totalinvestors == 0 ? 0 : (value / totalinvestors) * 100;
    });
    professioncount.forEach((key, value) {
      targetdata.profession[key] =
          totalinvestors == 0 ? 0 : (value / totalinvestors) * 100;
    });
    // print('done');

    /*targetdata.country.forEach((key, value) {
      print(key);
      print(value);
    });
    targetdata.agegrp.forEach((key, value) {
      print(key);
      print(value);
    });
    targetdata.gender.forEach((key, value) {
      print(key);
      print(value);
    });
    targetdata.profession.forEach((key, value) {
      print(key);
      print(value);
    });*/

    print('done');
    ideastarget[ideaid] = targetdata;
    return ideastarget[ideaid];
  }

  Future<void> add(
      {String collectionpath, Map<String, Object> data, Idea idea}) async {
    final ref =
        await FirebaseFirestore.instance.collection(collectionpath).add(data);
    idea.id = ref.id;
    // idea.investorids = [];
    //idea.likesids = [];
    print('adding');
    print(idea.title);
    print(idea.id);
    print(idea.about);
    print(idea.description);
    print(idea.private);
    print(idea.investor);
    print(idea.investorids);
    print(idea.likesids);
    print(idea.catid);
    print(idea.cattitle);

    _myideas.add(idea);
    notifyListeners();
  }

  Future<void> update(
      {String ideaid, Map<String, Object> data, Idea idea}) async {
    await FirebaseFirestore.instance
        .collection('ideas')
        .doc(ideaid)
        .update(data);

    int idx = _myideas.indexWhere((element) => element.id == ideaid);

    if (idx >= 0) {
      _myideas[idx] = idea;
    }

    notifyListeners();
  }

  Future<void> delete({String ideaid}) async {
    await FirebaseFirestore.instance.collection('ideas').doc(ideaid).delete();

    _myideas.removeWhere((element) => element.id == ideaid);

    notifyListeners();
  }

  Idea getidea(String ideaid) {
    return _myideas.firstWhere((element) => element.id == ideaid);
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

  Future<void> reporttrash(String ideaid) async {
    if (likestrack.containsKey(ideaid)) return;

    await incscore(ideaid);
    FirebaseFirestore.instance
        .collection('ideas')
        .doc(ideaid)
        .collection('likes')
        .add({'uid': FirebaseHelper.getid()});
    print('done');

    likestrack[ideaid] = true;
  }

  void clear() {
    _myideas.clear();
    ideastarget.clear();
    _feedbacks.clear();
  }
}

/*class UserIdeas with ChangeNotifier {
  //have 2 lits 1 users and one for global

  String token;
  UserIdeas olduserideas;
  List<Idea> i = [];
  Map<String, List<Idea>> _userideas = {};
  String userid;

  UserIdeas(this.token, this.userid, this._userideas);

  Map<String, List<Idea>> get userideas {
    return {..._userideas};
  }

  Idea getidea(String id) {
    return _userideas['admin'].firstWhere((element) => element.id == id);
  }

  Future<void> initilize([bool global = false]) async {
    String query = global ? '' : '&orderBy="userid"&equalTo="$userid"';
    var url = Uri.parse(
        'https://pitch-82e15-default-rtdb.firebaseio.com/ideas.json?auth=$token$query');

    var res = await http.get(url);

    print('status code: ${res.statusCode}');
    print('Response body: ${res.body}');

    var map = jsonDecode(res.body);

    List<Idea> ideas = [];
    _userideas['admin'] = ideas;

    map.forEach((key, value) {
      _userideas['admin'].insert(
          0,
          Idea(
            id: key,
            title: value['title'],
            about: value['about'],
            description: value['description'],
            img: value['image'],
            investor: value['investor'],
            private: value['private'],
          ));
    });

    print('firebase');
    print(map['-MWebgOOx5pJc8ZIrk5I']);
    print('done');
  }

  Future<void> add(String id, Idea idea) async {
    var url = Uri.parse(
        'https://pitch-82e15-default-rtdb.firebaseio.com/ideas.json?auth=$token');

    var response = await http.post(
      url,
      body: jsonEncode({
        'title': idea.title,
        'about': idea.about,
        'description': idea.description,
        'image': idea.img,
        'investor': idea.investor,
        'private': idea.private,
        'userid': userid,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

//First decode will convert in map the extract the name
    idea.id = json.decode(response.body)['name'];

    if (_userideas.containsKey(id)) {
      _userideas[id].add(idea);
    } else {
      List<Idea> ideas = [idea];
      _userideas[id] = ideas;
    }
    notifyListeners();
  }

  Future<void> update(Idea idea) async {
    var url = Uri.parse(
        'https://pitch-82e15-default-rtdb.firebaseio.com/ideas/${idea.id}.json?auth=$token');

    var response = await http.patch(url,
        body: jsonEncode({
          'title': idea.title,
          'about': idea.about,
          'description': idea.description,
          'image': idea.img,
          'investor': idea.investor,
          'private': idea.private,
        }));

    print('response status ${response.statusCode}');
    print('response body ${response.body}');
    int idx =
        _userideas['admin'].indexWhere((element) => element.id == idea.id);

    _userideas['admin'][idx] = idea;

    notifyListeners();
  }

  Future<void> delete(String id) async {
    print(id);
    var url = Uri.parse(
        'https://pitch-82e15-default-rtdb.firebaseio.com/ideas/$id.json?auth=$token');

    var response = await http.delete(url);

    print('response status ${response.statusCode}');
    print('response body ${response.body}');

    _userideas['admin'].removeWhere((element) => element.id == id);

    notifyListeners();
  }
}*/
