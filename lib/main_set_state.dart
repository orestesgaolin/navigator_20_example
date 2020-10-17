// ignore_for_file: omit_local_variable_types
import 'package:flutter/material.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatefulWidget {
  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  final pages = <Page>[];
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    pages.add(
      MyCustomPage(
        builder: (_) => HomePage(
          onAddPage: () {
            pages.add(
              MyCustomPage(
                builder: (_) => DetailsPage(),
                key: const Key('DetailsPage'),
              ),
            );
            setState(() {});
          },
        ),
        key: const Key('HomePage'),
      ),
    );
    // pages.addAll([
    //   MyCustomPage(
    //     builder: (_) => SecondLevelPage(
    //       goToThirdLevel: goToThirdLevel,
    //     ),
    //     key: const Key('SecondLevelPage'),
    //   ),
    //   MyCustomPage(
    //     builder: (_) => ThirdLevelPage(
    //       removeSecondLevel: removeSecondLevel,
    //       removeHomePage: removeHomePage,
    //     ),
    //     key: const Key('ThirdLevelPage'),
    //   ),
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // navigatorKey: _navigatorKey,
      // onGenerateRoute: (_) => null,
      // builder: (context, child) {
      //   return Navigator(
      //     key: _navigatorKey,
      //     pages: List.of(pages),
      //     onPopPage: _onPopPage,
      //   );
      // },
      home: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
        child: Navigator(
          key: _navigatorKey,
          pages: List.of(pages),
          onPopPage: _onPopPage,
        ),
      ),
    );
  }

  // void removeSecondLevel() {
  //   pages.removeAt(pages.length - 2);
  //   setState(() {});
  // }

  // void removeHomePage() {
  //   pages.removeAt(0);
  //   setState(() {});
  // }

  // void goToThirdLevel() {
  //   pages.add(MyCustomPage(
  //     builder: (_) => ThirdLevelPage(
  //       removeSecondLevel: removeSecondLevel,
  //       removeHomePage: removeHomePage,
  //     ),
  //     key: const Key('ThirdLevelPage'),
  //   ));
  //   setState(() {});
  // }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    pages.remove(route.settings);
    return route.didPop(result);
  }
}

/// {@template myCustomPage}
/// Custom implementation of [Page]
///
/// To create new page wrap it with [MyCustomPage].
///
/// {@tool snippet}
///
/// Typical usage is as follows:
///
/// ```dart
/// MyCustomPage(
///    builder: (_) => HomePage(),
///    key: const Key('HomePage'),
/// ),
/// ```
/// {@end-tool}
/// {@endtemplate}
class MyCustomPage<T> extends Page<T> {
  /// {@macro myCustomPage}
  const MyCustomPage({
    @required this.builder,
    String name,
    Key key,
  }) : super(key: key, name: name);
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: builder,
    );
  }

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Page) {
      return key == other.key;
    } else {
      return super == other;
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key, this.onAddPage}) : super(key: key);

  final VoidCallback onAddPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: TextButton(
        child: Text('Add page'),
        onPressed: onAddPage,
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
        backgroundColor: Colors.red,
      ),
      body: Center(child: Text('Details Page')),
    );
  }
}

class SecondLevelPage extends StatelessWidget {
  const SecondLevelPage({Key key, this.goToThirdLevel}) : super(key: key);
  final VoidCallback goToThirdLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecondLevel'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: FlatButton(
          onPressed: goToThirdLevel,
          child: Text('Go to 3.'),
        ),
      ),
    );
  }
}

class ThirdLevelPage extends StatefulWidget {
  const ThirdLevelPage({
    Key key,
    this.removeHomePage,
    this.removeSecondLevel,
  }) : super(key: key);

  final VoidCallback removeHomePage;
  final VoidCallback removeSecondLevel;

  @override
  _ThirdLevelPageState createState() => _ThirdLevelPageState();
}

class _ThirdLevelPageState extends State<ThirdLevelPage> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
    print(counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ThirdLevel'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: widget.removeHomePage,
              child: Text('Remove Home Page'),
            ),
            RaisedButton(
              onPressed: widget.removeSecondLevel,
              child: Text('Remove Second Level Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => increment(),
        child: Text('$counter'),
      ),
    );
  }
}

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    List<RouteTransitionRecord> newPageRouteHistory,
    Map<RouteTransitionRecord, RouteTransitionRecord>
        locationToExitingPageRoute,
    Map<RouteTransitionRecord, List<RouteTransitionRecord>>
        pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];
    // This method will handle the exiting route and its corresponding pageless
    // route at this location. It will also recursively check if there is any
    // other exiting routes above it and handle them accordingly.
    void handleExitingRoute(RouteTransitionRecord location, bool isLast) {
      final RouteTransitionRecord exitingPageRoute =
          locationToExitingPageRoute[location];
      if (exitingPageRoute == null) return;
      if (exitingPageRoute.isWaitingForExitingDecision) {
        final bool hasPagelessRoute =
            pageRouteToPagelessRoutes.containsKey(exitingPageRoute);
        final bool isLastExitingPageRoute =
            isLast && !locationToExitingPageRoute.containsKey(exitingPageRoute);
        if (isLastExitingPageRoute && !hasPagelessRoute) {
          exitingPageRoute.markForPop(exitingPageRoute.route.currentResult);
        } else {
          exitingPageRoute
              .markForComplete(exitingPageRoute.route.currentResult);
        }
        if (hasPagelessRoute) {
          final List<RouteTransitionRecord> pagelessRoutes =
              pageRouteToPagelessRoutes[exitingPageRoute];
          for (final RouteTransitionRecord pagelessRoute in pagelessRoutes) {
            assert(pagelessRoute.isWaitingForExitingDecision);
            if (isLastExitingPageRoute &&
                pagelessRoute == pagelessRoutes.last) {
              pagelessRoute.markForPop(pagelessRoute.route.currentResult);
            } else {
              pagelessRoute.markForComplete(pagelessRoute.route.currentResult);
            }
          }
        }
      }
      results.add(exitingPageRoute);

      // It is possible there is another exiting route above this exitingPageRoute.
      handleExitingRoute(exitingPageRoute, isLast);
    }

    // Handles exiting route in the beginning of list.
    handleExitingRoute(null, newPageRouteHistory.isEmpty);

    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      final bool isLastIteration = newPageRouteHistory.last == pageRoute;
      if (pageRoute.isWaitingForEnteringDecision) {
        if (!locationToExitingPageRoute.containsKey(pageRoute) &&
            isLastIteration) {
          pageRoute.markForPush();
        } else {
          pageRoute.markForAdd();
        }
      }
      results.add(pageRoute);
      handleExitingRoute(pageRoute, isLastIteration);
    }
    return results;
  }
}
