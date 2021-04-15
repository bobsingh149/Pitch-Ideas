import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:pitch/helper/firebasequeries.dart';
import 'package:provider/provider.dart';

class AllIdeasItem extends StatefulWidget {
  final title;
  final about;
  final id;
  final ideaowner;
  final cattitle;
  final description;
  final bool invest;

  AllIdeasItem(
      {this.id,
      this.title,
      this.ideaowner,
      this.about,
      this.cattitle = 'default',
      this.invest,
      this.description = 'default'});
  @override
  _AllIdeasItemState createState() => _AllIdeasItemState();
}

class _AllIdeasItemState extends State<AllIdeasItem> {
  UserIdeas userIdeas;
  Contactsdata contactsdata;
  bool disable = false;
  TextEditingController feedback = TextEditingController();

  Future<void> invest(String id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You can now connect to idea owner'),
        duration: Duration(seconds: 4),
      ),
    );
    await contactsdata.invest(widget.id,widget.ideaowner);

    setState(() {
      disable = true;
    });
  }

  Future<void> teamup(String ideaownerid) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Idea owner added to your team up contacts'),
        duration: Duration(seconds: 4),
      ),
    );
    await contactsdata.teamup(ideaid: widget.id,otherpersonid: ideaownerid);
  }

  Future<void> sendfeedback() async {
    print('feedback ${feedback.text}');
    if (feedback.text.trim().isEmpty) {
      print('returning');
      return;
    }

    final text = feedback.text;
    feedback.text = '';

    await userIdeas.sendfeedback(widget.id, text);

    // FocusScope.of(context).unfocus();

    print('executed');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    contactsdata = Provider.of<Contactsdata>(context, listen: false);
    userIdeas = Provider.of<UserIdeas>(context, listen: false);
    final texttheme = Theme.of(context).textTheme;
    return Container(
        child: Row(
      children: [
        Column(
          //overflow: Overflow.visible,
          // alignment: Alignment.centerRight,
          children: [
            Container(
              height: 550,
              width: 320,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.amber,
                      //Colors.purple,
                      //Colors.green,
                      Colors.lightBlue,
                      Colors.pink,
                    ]),
              ),
              margin: EdgeInsets.only(left: 25),
              alignment: Alignment.center,
              child: GridTile(
                //  header: Icon(Icons.lightbulb),

                child: Container(
                  // height: 300,
                  // width: 300,
                  child: Column(
                    children: [
                      Container(
                        // color: Colors.red,
                        alignment: Alignment.center,
                        child: FittedBox(
                            child: Text(
                          widget.title,
                          style: texttheme.headline2,
                        )),
                      ),
                      SizedBox(height: 15),
                      Container(
                          //  height: 100,
                          //width: double.infinity,
                          alignment: Alignment.centerLeft,
                          // color: Colors.green,

                          child:
                              Text(widget.about, style: texttheme.bodyText1)),
                      SizedBox(height: 15),
                      Container(
                          //height: 200,
                          alignment: Alignment.centerLeft,
                          // color: Colors.amber,
                          child: Text(widget.description,
                              style: texttheme.subtitle2)),
                    ],
                  ),
                ),
                footer: GridTileBar(
                  title: Text('Category'),
                  backgroundColor: Colors.black26,
                  subtitle: FittedBox(child: Text(widget.cattitle)),
                ),
              ),
            ),
            Container(
              //  color: Colors.red,
              //height: 230,
              width: 270,
              child: Wrap(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.horizontal,
                spacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: !widget.invest
                          ? null
                          : disable
                              ? null
                              : () => invest(widget.id),
                      icon: Icon(
                        Icons.monetization_on,
                        color: !widget.invest
                            ? null
                            : disable
                                ? Colors.black54
                                : Colors.white,
                      ),
                      label: Text(
                        'Invest',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton.icon(
                      onPressed: () {
                        teamup(widget.ideaowner);
                      },
                      icon: FaIcon(FontAwesomeIcons.userFriends),
                      label: Text('Team up now')),
                  ElevatedButton.icon(
                      /*onPressed: () async {
                          //print(val);
                          print('trying');
                          await sendfeedback();
                          print('done');
                        },*/
                      onPressed: () {
                        print('working');
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (ctx) {
                              return Container(
                                height: 300,
                                // color: Colors.red,
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Write your feedback',
                                  ),
                                  controller: feedback,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (val) async {
                                    print(val);
                                    print('trying');
                                    await sendfeedback();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Feedback sent successfully'),
                                        duration: Duration(seconds: 4),
                                      ),
                                    );
                                    print('done');
                                  },
                                ),
                              );
                            });
                      },
                      icon: FaIcon(FontAwesomeIcons.comment),
                      label: Text('Feedback')),
                  ElevatedButton(
                    onPressed: () {
                      print('working');
                        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thanks for your feedback'),
        duration: Duration(seconds: 4),
      ),
    );
                      userIdeas.reporttrash(widget.id);
                      print('done');
                    },
                    child: Container(
                      color: Colors.deepPurple,
                      height: 30,
                      width: 100,
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FaIcon(FontAwesomeIcons.lightbulb),
                            SizedBox(
                              width: 7,
                            ),
                            Text('Relevant to me'),
                          ],
                        ),
                      ),
                    ),
                    //label: Text('Report')
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: 15,
        ),
      ],
    ));
  }
}
