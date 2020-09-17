import 'package:flutter/material.dart';

import 'page_manager.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key, this.isNavigator2 = true}) : super(key: key);
  final bool isNavigator2;

  @override
  Widget build(BuildContext context) {
    final navigator = isNavigator2 ? '2.0' : '1.0';
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page (Navigator $navigator)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isNavigator2)
              RaisedButton(
                onPressed: () => PageManager.of(context).openDetails(),
                child: Text('Open Details with 2.0'),
              )
            else
              RaisedButton(
                onPressed: () => Navigator.push(
                  context,
                  DetailsPage.route,
                ),
                child: Text('Open Details with 1.0'),
              ),
            if (isNavigator2)
              RaisedButton(
                onPressed: () => PageManager.of(context).pushTwoPages(),
                child: Text('Push two pages to stack'),
              ),
            RaisedButton(
              onPressed: () => PageManager.of(context).switchNavigatorVersion(),
              child: Text('Switch Navigator'),
            )
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key key, this.isNavigator2 = true}) : super(key: key);
  final bool isNavigator2;

  static Route get route =>
      MaterialPageRoute(builder: (_) => DetailsPage(isNavigator2: false));

  @override
  Widget build(BuildContext context) {
    final navigator = isNavigator2 ? '2.0' : '1.0';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Details Page (Navigator $navigator)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isNavigator2)
              RaisedButton(
                onPressed: () => PageManager.of(context).addOtherPageBeneath(),
                child: Text('Add OtherPage beneath with 2.0'),
              )
            else
              RaisedButton(
                onPressed: () {
                  /// you could also try with Navigator.replace()
                  /// or Navigator.replaceRouteBelow() but for that you
                  /// need to remember current route
                  Navigator.pushAndRemoveUntil(
                    context,
                    CustomPageBuilder(
                      // <-- note custom builder to remove animation
                      builder: (_) => OtherPage(),
                    ),
                    (route) => route.isFirst,
                  );
                  Navigator.push(
                    context,
                    CustomPageBuilder(
                      // <-- note custom builder to remove animation
                      builder: (_) => DetailsPage(isNavigator2: false),
                    ),
                  );
                },
                child: Text('Add OtherPage beneath with 1.0'),
              ),
            if (isNavigator2)
              RaisedButton(
                onPressed: () => PageManager.of(context).makeRootPage(),
                child: Text('Make this page a root page with 2.0'),
              ),
            if (isNavigator2)
              RaisedButton(
                onPressed: () => PageManager.of(context).replaceTopWithOther(),
                child: Text('Replace this page with Other Page'),
              ),
          ],
        ),
      ),
    );
  }
}

class OtherPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => OtherPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Other Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}

class CustomPageBuilder extends PageRoute with MaterialRouteTransitionMixin {
  CustomPageBuilder({
    @required this.builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  bool transitioned = false;

  @override
  final WidgetBuilder builder;

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
}
