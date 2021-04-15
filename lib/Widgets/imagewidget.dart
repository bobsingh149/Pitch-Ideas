import 'dart:io';

import 'package:flutter/material.dart';

class ImageWid extends StatelessWidget {
  final title;
  final File img;
  Function del;

  ImageWid({this.title, this.img,this.del});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        del(title);
      },
      child: ListTile(
        leading: Text(title),
        title: Image.file(img), //:Text('No image'),
      ),
    );
  }
}
