import 'package:flutter/material.dart';
import 'package:pitch/Providers/imagedata.dart';
import 'package:pitch/Widgets/imageinput.dart';
import 'package:pitch/Widgets/imagewidget.dart';
import 'package:provider/provider.dart';

class MyImages extends StatefulWidget {
  static const String routename = '/myimages';
  @override
  _MyImagesState createState() => _MyImagesState();
}

class _MyImagesState extends State<MyImages> {
  bool init = true;
  bool isloding = false;
  ImageData imgdata;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      imgdata = Provider.of<ImageData>(context);
      setState(() {
        isloding = true;
        //While we are getting data we don't wont to use null list so
        //don't execute that code just show some other widget
        //once we get data then use our list
      });
      imgdata.initdata('Users').then((value) {
        setState(() {
          isloding = false;
          // so our list will only be
          //shown once the future is resolved
          //very very important
        });
      });
    }
    init = false;
    super.didChangeDependencies();
  }
Future<void> refresh() async
{
  await imgdata.initdata('Users');
}
  @override
  Widget build(BuildContext context) {
    final imagedata = Provider.of<ImageData>(context,listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Images'),
        actions: [
          FloatingActionButton(onPressed: () {
            Navigator.of(context).pushNamed(ImageInput.routename);
          })
        ],
      ),
      body: isloding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
                children: imagedata.imglist.map((e) {
                return ImageWid(
                  title: e.title,
                  img: e.img,
                  del: imagedata.delete,
                );
              }).toList()),
          ),
    );
  }
}
