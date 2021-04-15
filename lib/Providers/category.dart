import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pitch/helper/firebasequeries.dart';
//  Add science theory/thesis

class Category {
  String id;
  String title;
  String url;
  bool isfav;

  Category(
      {@required this.id,
      @required this.title,
      @required this.url,
      this.isfav = false});
}

class CategoryData with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> _favorites = [];
  List<Category> get category {
    return [..._categories];
  }

  List<Category> get favorites {
    return [..._favorites];
  }

  Future<void> initilize() async {
    if (_categories.isNotEmpty) return;

    
    print('calling');
    var catlist;
    DocumentSnapshot favsnaps;

    final catsnaps =
        await FirebaseFirestore.instance.collection('categories').get();

    catlist = catsnaps.docs;

    print('catlist ${catlist.length}');
    favsnaps = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseHelper.getid())
        .get();

    for (int idx = 0; idx < catlist.length; idx++) {
      final bool isfav = favsnaps.get((idx + 1).toString());
      print('isfav for $idx $isfav');

      final catmap = catlist[idx].data();
      Category category = new Category(
        id: catmap['id'],
        title: catmap['title'],
        url: catmap['url'],
        isfav: isfav,
      );

      _categories.add(category);

      if (category.isfav == true) _favorites.add(category);
    }

    //  notifyListeners();
  }

  Future<void> setfavorite(Category c) async {
    c.isfav = !c.isfav;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseHelper.getid())
        .update({c.id: c.isfav});

    bool f = false;
    for (int i = 0; i < _favorites.length; i++) {
      if (_favorites[i].id == c.id) {
        _favorites.removeAt(i);
        f = true;
        break;
      }
    }

    if (!f) _favorites.add(c);

    notifyListeners();
  }

  void clear() {
    _categories.clear();
    _favorites.clear();
  }
}
