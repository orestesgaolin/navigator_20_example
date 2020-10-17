import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:navigator_example/screens/other_screen.dart';

import 'details_screen.dart';

class Navigator10Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () => Navigator.of(context).push(DetailsScreen.route),
            child: Text('Open Details with 1.0'),
          ),
          Gap(10),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(OtherScreen.route);
              Navigator.of(context).push(DetailsScreen.route);
            },
            child: Text('Push two pages to stack with 1.0'),
          ),
          Gap(10),
          Text(
            'Note a redundant (double) animation when opening 2 pages at once',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
