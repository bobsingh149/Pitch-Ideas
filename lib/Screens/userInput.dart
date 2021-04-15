import 'package:flutter/material.dart';
import 'package:pitch/Providers/globalData.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/Screens/ShowMyIdeas.dart';
import 'package:pitch/Screens/TabScreen.dart';
import 'package:pitch/Screens/allIdeas.dart';
import 'package:pitch/Screens/myideas.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:pitch/Widgets/imageinput.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class UserInput extends StatefulWidget {
  static const String routename = '/userinput';
  //final String categoryid;
  //UserInput(this.categoryid);

  @override
  _UserInputState createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  Idea idea = new Idea(uid: FirebaseHelper.getid());

  bool edit = false;
  String ideaid;

  UserIdeas useridea;
  bool isinit = true;

  String about = '';
  String des = '';

  bool isloading = false;

  final FocusNode focus1 = FocusNode();

  final FocusNode focus2 = FocusNode();

  bool investor = false;

  bool private = false;

  var formkey = GlobalKey<FormState>();

  //TextEditingController image = TextEditingController();
  String url = '';

  TextEditingController titlecontroller = TextEditingController();
  String catid;
  String cattitle;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      edit = args['edit'];
      if (edit) {
        ideaid = args['id'];
      } else {
        catid = args['catid'];
        cattitle = args['cattitle'];
      }
      useridea = Provider.of<UserIdeas>(context, listen: false);

      if (edit) {
        Idea ideaToEdit = useridea.getidea(ideaid);

        idea = ideaToEdit;

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

        titlecontroller.text = ideaToEdit.title;
        about = ideaToEdit.about;
        des = ideaToEdit.description;
        //image.text = ideaToEdit.img;
        investor = ideaToEdit.investor;
        private = ideaToEdit.private;
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    focus1.dispose();
    focus2.dispose();
    //image.dispose();
    titlecontroller.dispose();
    super.dispose();
  }

  Future<void> saveform() async {
    bool valid = formkey.currentState.validate();
    if (!valid) return;
    formkey.currentState.save();

   

    setState(() {
      isloading = true;
    });

    /* setState(() {
      isloading = true;
    });*/
    if (edit) {
      print('editing');
     /* print(idea.title);
      print(idea.id);
      print(idea.about);
       print(idea.description);
      print(idea.private);
      print(idea.investor);
      print(idea.investorids);
      print(idea.likesids);
      print(idea.catid);
      print(idea.cattitle);*/

      await useridea.update(ideaid: ideaid, idea: idea, data: {
        'title': idea.title,
        'about': idea.about,
        'description': idea.description,
        'investor': idea.investor,
        'private': idea.private,
        'uid': FirebaseHelper.getid(),
        //'image': idea.img,
      });
    } else {
       idea.catid = catid;
    idea.cattitle = cattitle;
      print('idea id ${idea.id}');
      await useridea.add(collectionpath: 'ideas', idea: idea, data: {
        'title': idea.title,
        'about': idea.about,
        'description': idea.description,
        'investor': idea.investor,
        'private': idea.private,
        'uid': FirebaseHelper.getid(),
        //'image': idea.img,
        'catid': idea.catid,
        'cattilte': idea.cattitle,
        'score': 0,
      });
    }

    setState(() {
      isloading = false;
    });

    /*setState(() {
      isloading = true;
    });

    if (widget.edit) {
      idea.id = widget.id;
      await useridea.update(idea);
    } else {
      try {
        await useridea.add('admin', idea);
      } catch (error) {
        print(error.toString());
      }
    }
    //setState(() {
    //isloading = false;
    //});
    print('done');*/

    Navigator.of(context).pushReplacementNamed(Tabs.routename, arguments: 1);
  }

  Widget build(BuildContext context) {
    useridea = Provider.of<UserIdeas>(context, listen: false);
    //final args = ModalRoute.of(context).settings.arguments as Map<String,int>;
    //final id = args['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Your Idea'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveform();
              }),
          FloatingActionButton(onPressed: () {
            Navigator.of(context).pushNamed(AllIdeas.routename);
          })
        ],
      ),
      drawer: Drawers(),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: formkey,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'What\'s your idea',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: titlecontroller,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(focus1);
                        },
                        onSaved: (String val) {
                          idea.title = val;
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return 'This field can\'t be empty';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: about,
                        decoration: InputDecoration(
                          labelText: 'About',
                          hintText: 'Briefly describe your idea',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        //textInputAction: TextInputAction.next,
                        focusNode: focus1,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(focus2);
                        },
                        onSaved: (String val) {
                          idea.about = val;
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return 'This field can\'t be empty';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: des,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Optional - Explain in detail your idea',
                        ),
                        keyboardType: TextInputType.multiline,
                        focusNode: focus2,
                        autocorrect: true,
                        maxLines: 6,
                        // textInputAction: TextInputAction.done,
                        onSaved: (String val) {
                          idea.description = val;
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return 'This field can\'t be empty';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      /* Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 150,
                            width: 130,
                            child: url.isEmpty
                                ? FittedBox(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.amber,
                                        child: FittedBox(
                                            child: Text(
                                          'No image to preview yet',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  170, 35, 90, 1)),
                                        ))))
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(url),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText:
                                      'Upload the Pitcure if applicable'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.url,
                              controller: image,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  url = image.text;
                                });
                              },
                              onSaved: (String val) {
                                idea.img = val;
                              },
                              validator: (val) {
                                if (val.endsWith('.jpg') ||
                                    val.endsWith('.jpeg') ||
                                    val.endsWith('.png'))
                                  return null;
                                else
                                  return 'Upload Valid Image';
                              },
                            ),
                          ),
                        ],
                      ),*/

                      //Spacer(),
                      SizedBox(height: 10),
                      SwitchListTile(
                          title: Text('Find Investors'),
                          subtitle: FittedBox(
                              child: Text(
                                  'If selected your ideas will be shown to verified investors')),
                          //tileColor: Colors.deepOrange,
                          value: investor,
                          onChanged: (newval) {
                            setState(() {
                              investor = newval;
                              idea.investor = newval;
                            });
                          }),
                      SizedBox(height: 10),
                      SwitchListTile(
                          title: Text('Private'),
                          subtitle: FittedBox(
                              child: Text(
                                  'Only you will see it you can edit it later')),
                          //tileColor: Colors.deepOrange,
                          value: private,
                          onChanged: (newval) {
                            setState(() {
                              private = newval;
                              idea.private = newval;
                            });
                          }),
                      Container(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            onPressed: saveform,
                            child: Icon(Icons.save),
                          ))
                    ],
                  )),
            ),
    );
  }
}
