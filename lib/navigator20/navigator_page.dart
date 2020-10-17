import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:navigator_example/page_manager.dart';

class Navigator20Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () => PageManager.of(context).openDetails(),
            child: Text('Open Details with 2.0'),
          ),
          Gap(10),
          RaisedButton(
            onPressed: () => PageManager.of(context).pushTwoPages(),
            child: Text('Push two pages to stack with 2.0'),
          ),
          Gap(10),
          Text(
            'Note no redundant (double) animations when opening 2 pages at once',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
