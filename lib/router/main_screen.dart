import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../main_router.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Router Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Main Router Screen'),
            Gap(20),
            OutlineButton(
              child: Text('Open Details'),
              onPressed: () {
                RoutePageManager.of(context).openDetails();
              },
            ),
          ],
        ),
      ),
    );
  }
}
