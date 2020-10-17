import 'package:flutter/material.dart';
import 'package:navigator_example/screens/other_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key key}) : super(key: key);

  static Route get route => MaterialPageRoute(builder: (_) => DetailsScreen());

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
              onPressed: () {
                /// you could also try with Navigator.replace()
                /// or Navigator.replaceRouteBelow() but for that you
                /// need to remember current route
                Navigator.pushAndRemoveUntil(
                  context,
                  CustomPageBuilder(
                    // <-- note custom builder to remove animation
                    page: MaterialPage(child: OtherScreen()),
                  ),
                  (route) => route.isFirst,
                );
                Navigator.push(
                  context,
                  CustomPageBuilder(
                    // <-- note custom builder to remove animation
                    page: MaterialPage(child: DetailsScreen()),
                  ),
                );
              },
              child: Text('Add Other Screen beneath with 1.0'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPageBuilder extends PageRoute with MaterialRouteTransitionMixin {
  CustomPageBuilder({
    @required MaterialPage page,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : _page = page,
        super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  bool transitioned = false;

  final MaterialPage _page;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transitioned) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    } else {
      return child;
    }
  }

  @override
  bool didPop(result) {
    // We're allowing animations from now on
    transitioned = true;
    return super.didPop(result);
  }

  @override
  bool get maintainState => false;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }
}
