import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:pitch/Providers/imagedata.dart';
import 'package:pitch/Screens/Myimages.dart';
import 'package:provider/provider.dart';

enum mode {
  cam,
  gal,
}

class ImageInput extends StatefulWidget {
  static const String routename = '/imageinput';
  final Function setimage;
  ImageInput(this.setimage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File showimg;
  File savedfile;
  TextEditingController imgtitle = TextEditingController();
  Future<void> getimage(mode m) async {
    final imgpicker = ImagePicker();

    var pickedfile;

    if (m == mode.cam) {
      pickedfile =
          await imgpicker.getImage(source: ImageSource.camera, maxWidth: 300,imageQuality: 70,
          maxHeight: 400);
    } else {
      pickedfile = await imgpicker.getImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        imageQuality:70 ,
        maxHeight: 400,
      );
    }

    showimg = File(pickedfile.path);

    final sysdirectory = await syspath.getApplicationDocumentsDirectory();

    final dir = path.join(sysdirectory.path, path.basename(showimg.path));

    savedfile = await showimg.copy(dir);

    print('saved image : ${savedfile.path}');
    print('temp image :  ${showimg.path}');

    setState(() {});

    widget.setimage(savedfile);
  }

  Future<void> save(String title, ImageData imgdata) async {
    if (imgdata == null || title == null) {
      print('invalid');
      return;
    }
    await imgdata.add(title, savedfile);
  }

  @override
  Widget build(BuildContext context) {
    final imgdataobject = Provider.of<ImageData>(context);
    return Container(
      /*appBar: AppBar(
        title: Text('Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              save(imgtitle.text,imgdataobject);
            },
          )
        ],
      ),*/
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // height: 150,
              //width: 130,
              //color: Colors.amber,
              child: savedfile == null
                  ? CircleAvatar(
                      radius: 75,
                      child: FittedBox(child: Text('No Image to preview yet')))
                  : CircleAvatar(
                      radius: 75,
                      backgroundImage: FileImage(savedfile),
                    ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () {
                      getimage(mode.cam);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Use Camera')),
                TextButton.icon(
                    label: Text('Choose from gallery'),
                    icon: Icon(Icons.file_copy),
                    onPressed: () {
                      getimage(mode.gal);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
