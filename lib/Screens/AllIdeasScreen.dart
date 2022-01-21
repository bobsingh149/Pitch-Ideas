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
      body: 
 
                 SingleChildScrollView(
                   child: Container(
                    // height: MediaQuery.of(context).size.height*0.9,
                    decoration: BoxDecoration(
                       gradient: LinearGradient(colors: [
                           Colors.blue[300],
                   
                        
                         
                            //Colors.orange[300],
                           // Colors.purple,
                            Colors.white54,

                            Colors.lightBlue[300],
                        
                        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    ),
                    child: AllIdeas(),
                ),
                 ),
            
          
         /* Container(
           // height: 25,
            width: double.infinity,
            //color: Colors.cyan,
            child: Text('Swipe Left to Right to browse all ideas',style:TextStyle(color: Colors.deepPurple)),
          ),*/

        
      
    );
  }
}
