import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  static const routename = '/info';
  final String name;
  //final String contactid;
  //final String url;
  final String gender;
  final String profession;
  final String country;
  final String age;

  Info({this.name, this.gender, this.age, this.country, this.profession});
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More Info')),
    body: SingleChildScrollView(
      child: Column(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 100),
              child: ListTile(
                leading: Text('Name'),
                
                title: Text(widget.name),
              //  tileColor: Colors.amber,
              ),
            ),
             Container(
              constraints: BoxConstraints(minHeight: 100),
              child: ListTile(
                leading: Text('Age'),
                
                title: Text(widget.age),
                //tileColor: Colors.amber,
              ),
            ),
             Container(
              constraints: BoxConstraints(minHeight: 100),
              child: ListTile(
                leading: Text('Gender'),
                
                title: Text(widget.gender),
                //tileColor: Colors.amber,
              ),
            ),
             Container(
              constraints: BoxConstraints(minHeight: 100),
              child: ListTile(
                leading: Text('Country'),
                
                title: Text(widget.country),
                //tileColor: Colors.amber,
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 100),
              child: ListTile(
                leading: Text('Profession'),
                
                title: Text(widget.profession),
                //tileColor: Colors.amber,
              ),
            ),
          ],
        ),
    ),
    );
  }
}
