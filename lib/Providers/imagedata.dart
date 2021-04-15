import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pitch/helper/sql.dart';

class Img {
  int id;
  String title;
  File img;

  Img({this.id, this.title, this.img});
}

class ImageData with ChangeNotifier {
  int counter = 0;
  List<Img> _imglist = [];

  List<Img> get imglist {
    return [..._imglist];
  }

  Future<void> add(String title, File image) async {
    counter++;
    await Sql.storedata('Users', {
      'id': counter,
      'title': title,
      'img': image.path,
    });

    notifyListeners();
  }

  Future<void> initdata(String table) async {
    _imglist.clear();
    final datamap = await Sql.fetchdata(table);

    print('user data map ${datamap.length}');
    for (int i = 0; i < datamap.length; i++) {
      print(datamap[i]);
    }

    for (int i = 0; i < datamap.length; i++) {
      _imglist.add(Img(
        id: datamap[i]['id'],
        title: datamap[i]['title'],
        img: File(datamap[i]['img']),
      ));
    }
    notifyListeners();
  }

  Future<void> delete(String title) async {
    final rowsaffected = await Sql.delete('Users', title);
    print('rows deleted $rowsaffected');
    _imglist.removeWhere((element) => element.title == title);
    notifyListeners();
  }
}
