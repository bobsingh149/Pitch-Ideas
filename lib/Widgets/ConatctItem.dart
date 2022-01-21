import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:pitch/Screens/info.dart';
import 'package:pitch/Widgets/contactpage.dart';

class ContactItem extends StatefulWidget {
  final String name;
  final String contactid;
  final String url;
  final String gender;
  final String profession;
  final String country;
  final String age;

  ContactItem(
      {this.name,
      this.contactid,
      this.url,
      this.gender,
      this.age,
      this.country,
      this.profession});
  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  String def;
  @override
  Widget build(BuildContext context) {
    final mytheme = Theme.of(context);
    if (widget.gender == 'male')
      def = 'assets/male.jpg';
    else
      def = 'assets/fe.jpg';
    return
        //height: 100,
        // color: Colors.amber,
        InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ContactPage.routename,
            arguments: {'name': widget.name, 'id': widget.contactid});
      },
      splashColor: Colors.pink,
      child: Column(
        children: [
          // height: 100,

          //Card(
            //elevation: 5,
            //shadowColor: mytheme.accentColor,
            //child:
             Container(
              height: 90,
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: mytheme.primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.amber),
              child: Row(children: [
                CircleAvatar(
                  backgroundImage: widget.url == 'na'
                      ? AssetImage(def)
                      : NetworkImage(widget.url),
                  radius: 39,
                ),
                SizedBox(
                  width: 35,
                ),
                Text(
                  widget.name,
                  style: mytheme.textTheme.headline3,
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.deepPurple,
                  heroTag:widget.contactid ,
                
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return Info(
                          age: widget.age,
                          country: widget.country,
                          gender: widget.gender,
                          name: widget.name,
                          profession: widget.profession,
                        );
                      }));
                    },
                    child: FaIcon(FontAwesomeIcons.info,color: Colors.amber,)),

                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                //tileColor: Colors.deepOrange,
              ]),
            ),
         // ),

          Divider(
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
