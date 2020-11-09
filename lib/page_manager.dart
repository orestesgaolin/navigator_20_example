import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigator_example/screens/other_screen.dart';
import 'package:provider/provider.dart';

import 'custom_page.dart';
import 'navigator20/details_screen.dart';
import 'main_screen.dart';
import 'navigator20/result_screen.dart';

class PageManager extends ChangeNotifier {
  /// it's important to provide new list for Navigator each time
  /// because it compares previous list with the next one on each [NavigatorState didUpdateWidget]
  List<Page> get pages => List.unmodifiable(_pages);
  Completer _resultCompleter;
  final List<Page> _pages = [
    MaterialPage(
      child: MainScreen(),
      key: Key('MainPage'),
    ),
  ];

  final _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static PageManager of(BuildContext context) {
    return Provider.of<PageManager>(context, listen: false);
  }

  void openDetails() {
    _pages.add(
      MaterialPage(
        child: DetailsScreen(),
        key: DetailsScreen.pageKey,
      ),
    );
    notifyListeners();
  }

  /// Simple method to use instead of `await Navigator.push(context, ...)`
  ///
  /// This way you can handle pushing pages that are
  /// expetected to return some value.
  ///
  /// Here I'm using single completer to wait for the result.
  ///
  /// The result can be set either by [returnWith] or by popping the page
  /// as you would normally do with old Navigator ([didPop] and [_setResult]).
  Future<bool> waitForResult() async {
    _resultCompleter = Completer<bool>();
    _pages.add(
      MaterialPage(
        child: ResultScreen(),
        key: ResultScreen.pageKey,
      ),
    );
    notifyListeners();
    return _resultCompleter.future;
  }

  /// This is custom method to pass returning value
  /// while popping the page. It can be considered as an example
  /// alternative to returning value with `Navigator.pop(context, value)`.
  void returnWith(bool value) {
    if (_resultCompleter != null) {
      _pages.removeLast();
      _resultCompleter.complete(value);
      notifyListeners();
    }
  }

  void addOtherPageBeneath({Widget child}) {
    final inserted = child != null
        ? MaterialPage(child: child, key: UniqueKey())
        : MaterialPage(
            child: OtherScreen(),
            key: Key('OtherPage${_pages.length - 1}'),
          );
    _pages.insert(
      _pages.length - 1,
      inserted,
    );
    notifyListeners();
  }

  void pushTwoPages() {
    _pages.addAll(
      [
        // You can also use CustomPage instead of MaterialPage
        CustomPage(
          builder: (_) => OtherScreen(),
          key: UniqueKey(),
        ),
        CustomPage(
          builder: (_) => DetailsScreen(),
          key: DetailsScreen.pageKey,
        ),
      ],
    );
    notifyListeners();
  }

  void makeRootPage() {
    _pages.removeRange(0, _pages.length - 1);
    notifyListeners();
  }

  bool isRootPage(Key key) {
    final value = _pages.elementAt(0).key == key;
    if (value) {
      notifyListeners();
    }
    return value;
  }

  void replaceTopWith(Widget child) {
    _pages.removeAt(_pages.length - 1);
    _pages.add(
      MaterialPage(
        child: child,
        key: UniqueKey(),
      ),
    );
    notifyListeners();
  }

  void _setResult(dynamic result) {
    if (result is bool && _resultCompleter != null) {
      _resultCompleter.complete(result);
    }
  }

  void didPop(Page page, dynamic result) {
    _pages.remove(page);
    if (result != null) {
      _setResult(result);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _resultCompleter?.complete();
  }
}
