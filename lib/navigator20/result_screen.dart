import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:navigator_example/page_manager.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key key}) : super(key: key);

  static const pageKey = Key('ResultScreen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This page shows how to return value from a page',
              textAlign: TextAlign.center,
            ),
            Gap(20),
            RaisedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Result with true via Navigator.pop'),
            ),
            Gap(20),
            RaisedButton(
              onPressed: () => PageManager.of(context).returnWith(true),
              child: Text('Result with true via custom method'),
            ),
          ],
        ),
      ),
    );
  }
}
