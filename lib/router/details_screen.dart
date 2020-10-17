import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../main_router.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key key, this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details $id'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$id',
              style: Theme.of(context).textTheme.headline3,
            ),
            Gap(20),
            OutlineButton(
              child: Text('Open Details'),
              onPressed: () {
                RoutePageManager.of(context).openDetails();
              },
            ),
            Gap(20),
            OutlineButton(
              child: Text('Reset to home'),
              onPressed: () {
                RoutePageManager.of(context).resetToHome();
              },
            ),
            Gap(20),
            OutlineButton(
              child: Text('Add new Details below'),
              onPressed: () {
                RoutePageManager.of(context).addDetailsBelow();
              },
            ),
          ],
        ),
      ),
    );
  }
}
