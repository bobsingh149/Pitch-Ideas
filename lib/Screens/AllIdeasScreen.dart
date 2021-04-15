import 'package:flutter/material.dart';
import 'package:pitch/Screens/allIdeas.dart';

class AllIdeasScreen extends StatefulWidget {
  static const routename = '/allideasscrren';
  @override
  _AllIdeasScreenState createState() => _AllIdeasScreenState();
}

class _AllIdeasScreenState extends State<AllIdeasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse All Ideas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white60,
                child: AllIdeas(),
              ),
            ),
          ),
          Container(
            //height: 100,
            width: double.infinity,
            color: Colors.white54,
            child: Text('Swipe Left to Right to browse all ideas',style:TextStyle(color: Colors.deepPurple)),
          ),

        ],
      ),
    );
  }
}
