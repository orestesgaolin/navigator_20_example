import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Screen'),
      ),
      body: Center(
        child: Icon(
          CupertinoIcons.question,
          size: 34,
        ),
      ),
    );
  }
}
