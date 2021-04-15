import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pitch/Widgets/contactpage.dart';

class ContactItem extends StatefulWidget {
  final String name;
  final String contactid;
  final String url;
  final String gender;
  ContactItem({this.name, this.contactid, this.url, this.gender});
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

          Card(
            elevation: 5,
            shadowColor: mytheme.accentColor,
            child: Container(
              height: 90,
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: mytheme.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.amber),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:  widget.url == 'na'
                      ? AssetImage(def)
                      : NetworkImage(widget.url),
                radius: 39,
                

               
                
                ),
                SizedBox(width: 35,),
           Text(
                  widget.name,
                  style: mytheme.textTheme.headline3,
                ),
                
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                //tileColor: Colors.deepOrange,
                ]
              ),
            ),
          ),

          Divider(
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
