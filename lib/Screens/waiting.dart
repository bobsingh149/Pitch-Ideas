import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading'),
      ),
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
