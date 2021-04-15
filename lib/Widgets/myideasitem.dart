import 'package:flutter/material.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/Screens/Contacts.dart';
import 'package:pitch/Screens/Feedback.dart';
import 'package:pitch/Screens/target.dart';
import 'package:pitch/Screens/userInput.dart';
import 'package:provider/provider.dart';

class MyIdeasItem extends StatefulWidget {
  final id;
  final title;
  final about;
  MyIdeasItem({this.id, this.title, this.about});
  @override
  _MyIdeasItemState createState() => _MyIdeasItemState();
}

class _MyIdeasItemState extends State<MyIdeasItem> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    UserIdeas userideas = Provider.of<UserIdeas>(context, listen: false);

    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        Navigator.of(context)
            .pushNamed(Target.routename, arguments: {'id': widget.id});
      },
      child: Container(
       // height: 250,
        color: isloading ? Colors.red : null,
        child: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Dismissible(
                    key: ValueKey(widget.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {
                      await userideas.delete(ideaid: widget.id);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red[900],
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                    child: Container(
                      height: 100,
                       //color: Colors.black,
                      child: Card(
                        elevation: 17,
                        shadowColor: Theme.of(context).primaryColor,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                /* LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.amber,
                                  Colors.blue,
                                  Colors.pink,
                                ]),*/
                                LinearGradient(
                                    colors: [
                                  Colors.teal,
                                  Colors.white54,
                                  Colors.amber,
                                ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.lightbulb,
                              color: Colors.deepPurple,
                            ),
                            title: Text(widget.title,style: Theme.of(context).textTheme.bodyText1),
                            subtitle: Text(widget.about,style: Theme.of(context).textTheme.subtitle1,),
                            hoverColor: Colors.amber,
                            trailing: Container(
                              width: 100,
                              color: Colors.black26,
                              child: Row(
                                children: [
                                  IconButton(
                                      color: Colors.deepPurple,
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            UserInput.routename,
                                            arguments: {
                                              'edit': true,
                                              'id': widget.id
                                            });
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red[600],
                                      onPressed: () async {
                                        bool f = true;
                                        f = await showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text(' Delete'),
                                                content: Text(
                                                    'Just checking are you sure'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      f = true;
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        f = false;
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text('No')),
                                                ],
                                              );
                                            });

                                        if (f == true) {

                                           setState(() {
                                          isloading = true;
                                        });
                                        await userideas.delete(
                                            ideaid: widget.id);

                                        setState(() {
                                          isloading = false;
                                        });
                                        } else {
                                          return;
                                        }

                                       
                                      }
                                      
                                      ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 2),
                  Wrap(
                direction: Axis.horizontal,
                
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(MyFeedback.routename, arguments: {
                              'ideaid': widget.id,
                              'title': widget.title,
                            });
                          },
                          icon: Icon(Icons.comment),
                          label: Text('See Feedbacks')),
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ContactScreen.routname, arguments: {
                              'inv': true,
                              'ideaid': widget.id,
                              'title': widget.title,
                            });
                          },
                          icon: Icon(Icons.monetization_on),
                          label: Text('See Investors')),


                            FittedBox(
                              child: TextButton(
                          onPressed: () {
                           Navigator.of(context)
            .pushNamed(Target.routename, arguments: {'id': widget.id});
                          },
                         // icon: Icon(Icons.comment),
                          child: Text('Target Audience ')),
                            ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
      ),
    );
  }
}
