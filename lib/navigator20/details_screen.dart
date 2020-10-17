import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:navigator_example/main_screen.dart';
import 'package:navigator_example/page_manager.dart';
import 'package:navigator_example/screens/other_screen.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key key}) : super(key: key);

  static const pageKey = Key('DetailsPage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Details Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => PageManager.of(context).addOtherPageBeneath(),
              child: Text('Add Other Screen beneath with 2.0'),
            ),
            Gap(20),
            RaisedButton(
              onPressed: () => PageManager.of(context).makeRootPage(),
              child: Text('Make this page a root page with 2.0'),
            ),
            Gap(20),
            Consumer<PageManager>(
              builder: (context, value, child) {
                if (value.isRootPage(pageKey)) {
                  return child;
                }
                return SizedBox();
              },
              child: RaisedButton(
                onPressed: () => PageManager.of(context)
                    .addOtherPageBeneath(child: MainScreen()),
                child: Text('Put MainPage again under this one 😅'),
              ),
            ),
            Gap(20),
            RaisedButton(
              onPressed: () =>
                  PageManager.of(context).replaceTopWith(OtherScreen()),
              child: Text('Replace this page with Other Screen with 2.0'),
            ),
          ],
        ),
      ),
    );
  }
}
