import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:navigator_example/page_manager.dart';

class Navigator20Screen extends StatefulWidget {
  @override
  _Navigator20ScreenState createState() => _Navigator20ScreenState();
}

class _Navigator20ScreenState extends State<Navigator20Screen> {
  bool result;

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
            'Note no redundant (double) animations\nwhen opening 2 pages at once',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          Gap(10),
          RaisedButton(
            onPressed: () async {
              setState(() {
                this.result = null;
              });
              final result = await PageManager.of(context).waitForResult();
              print(result);
              setState(() {
                this.result = result;
              });
            },
            child: Text(
              'Push and await result',
            ),
          ),
          if (result != null)
            Text(
              'Pop result: $result',
              style: Theme.of(context).textTheme.headline5,
            )
        ],
      ),
    );
  }
}
