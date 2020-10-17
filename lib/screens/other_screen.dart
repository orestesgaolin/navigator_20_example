import 'package:flutter/material.dart';

class OtherScreen extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => OtherScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Other Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Other Screen'),
          ],
        ),
      ),
    );
  }
}
