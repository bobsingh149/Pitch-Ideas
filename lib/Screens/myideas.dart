/*import 'package:flutter/material.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/Screens/userInput.dart';
import 'package:pitch/Widgets/ideaitem.dart';
import 'package:provider/provider.dart';

class MyIdeas extends StatefulWidget {
  static const String routename = '/userideas';

  @override
  _UserIdeasState createState() => _UserIdeasState();
}

class _UserIdeasState extends State<MyIdeas> {
  bool isloading = false;
  bool isinit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      var ideas = Provider.of<UserIdeas>(context);
      setState(() {
        isloading = true;
      });
      ideas.initilize().then((value) {
        setState(() {
          isloading = false;
        });
      });
    }

    isinit = false;

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final userideaobject = Provider.of<UserIdeas>(context, listen: true);

   // final userideas = userideaobject.userideas['admin'];

    // print(userideas[0].title);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Ideas'),
        actions: [
          FloatingActionButton(onPressed: () {
            Navigator.of(context).pushReplacementNamed(UserInput.routename,arguments: {'edit':false,'id':''});
          })
        ],
      ),
      body: isloading ?Center(child: CircularProgressIndicator(),)
      :ListView.builder(
        itemBuilder: (ctx, index) {
          return IdeaItem(
            title: userideas[index].title,
            about: userideas[index].about,
            img: userideas[index].img,
            id: userideas[index].id,
            del: userideaobject.delete,
          );
        },
        itemCount: userideas.length,
      ),
    );
  }
}*/
