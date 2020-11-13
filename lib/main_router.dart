import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router/details_screen.dart';
import 'router/main_screen.dart';
import 'router/unknown_screen.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  TheApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerDelegate: TheAppRouterDelegate(),
      routeInformationParser: TheAppRouteInformationParser(),
    );
  }
}

/// A delegate that is used by the [Router] widget to build and configure a
/// navigating widget.
///
/// This delegate is the core piece of the [Router] widget. It responds to
/// push route and pop route intent from the engine and notifies the [Router]
/// to rebuild. It also act as a builder for the [Router] widget and builds a
/// navigating widget, typically a [Navigator], when the [Router] widget
/// builds.
class TheAppRouterDelegate extends RouterDelegate<TheAppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TheAppPath> {
  TheAppRouterDelegate() {
    // This part is important because we pass the notification
    // from RoutePageManager to RouterDelegate. This way our navigation
    // changes (e.g. pushes) will be reflected in the address bar
    pageManager.addListener(notifyListeners);
  }
  final RoutePageManager pageManager = RoutePageManager();

  /// In the build method we need to return Navigator using [navigatorKey]
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoutePageManager>.value(
      value: pageManager,
      child: Consumer<RoutePageManager>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(pageManager.pages),
          );
        },
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }

    /// Notify the PageManager that page was popped
    pageManager.didPop(route.settings);

    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => pageManager.navigatorKey;

  @override
  TheAppPath get currentConfiguration => pageManager.currentPath;

  @override
  Future<void> setNewRoutePath(TheAppPath configuration) async {
    await pageManager.setNewRoutePath(configuration);
  }
}

class RoutePageManager extends ChangeNotifier {
  static RoutePageManager of(BuildContext context) {
    return Provider.of<RoutePageManager>(context, listen: false);
  }

  /// Here we are storing the current list of pages
  List<Page> get pages => List.unmodifiable(_pages);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<Page> _pages = [
    MaterialPage(
      child: MainScreen(),
      key: const Key('MainScreen'),
      name: '/',
    ),
  ];

  TheAppPath get currentPath {
    return parseRoute(Uri.parse(_pages.last.name));
  }

  void didPop(Page page) {
    _pages.remove(page);
    notifyListeners();
  }

  /// This is where we handle new route information and manage the pages list
  Future<void> setNewRoutePath(TheAppPath configuration) async {
    if (configuration.isUnknown) {
      // Handling 404
      _pages.add(
        MaterialPage(
          child: UnknownScreen(),
          key: UniqueKey(),
          name: '/404',
        ),
      );
    } else if (configuration.isDetailsPage) {
      // Handling details screens
      _pages.add(
        MaterialPage(
          child: DetailsScreen(id: configuration.id),
          key: UniqueKey(),
          name: '/details/${configuration.id}',
        ),
      );
    } else if (configuration.isHomePage) {
      // Restoring to MainScreen
      _pages.removeWhere(
        (element) => element.key != const Key('MainScreen'),
      );
    }
    notifyListeners();
    return;
  }

  void openDetails() {
    setNewRoutePath(TheAppPath.details(_pages.length));
  }

  void resetToHome() {
    setNewRoutePath(TheAppPath.home());
  }

  void addDetailsBelow() {
    _pages.insert(
      _pages.length - 1,
      MaterialPage(
        child: DetailsScreen(id: _pages.length),
        key: UniqueKey(),
        name: '/details/${_pages.length}',
      ),
    );
    notifyListeners();
  }
}

TheAppPath parseRoute(Uri uri) {
  // Handle '/'
  if (uri.pathSegments.isEmpty) {
    return TheAppPath.home();
  }

  // Handle '/details/:id'
  if (uri.pathSegments.length == 2) {
    if (uri.pathSegments[0] != 'details') return TheAppPath.unknown();
    var remaining = uri.pathSegments[1];
    var id = int.tryParse(remaining);
    if (id == null) return TheAppPath.unknown();
    return TheAppPath.details(id);
  }

  // Handle unknown routes
  return TheAppPath.unknown();
}

/// Parser inspired by https://github.com/acoutts/flutter_nav_2.0_mobx/blob/master/lib/main.dart
///
/// Using typed information instead of string allows for greater flexibility
class TheAppRouteInformationParser extends RouteInformationParser<TheAppPath> {
  @override
  Future<TheAppPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    return parseRoute(uri);
  }

  @override
  RouteInformation restoreRouteInformation(TheAppPath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/details/${path.id}');
    }
    return null;
  }
}

/// Class responsible for storing typed information about
/// the current navigation path in the app
class TheAppPath {
  final int id;

  TheAppPath.home() : id = null;

  TheAppPath.details(this.id);

  TheAppPath.unknown() : id = -1;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;

  bool get isUnknown => id == -1;
}
