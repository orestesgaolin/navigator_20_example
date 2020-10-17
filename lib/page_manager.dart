import 'package:flutter/material.dart';
import 'package:navigator_example/screens/other_screen.dart';
import 'package:provider/provider.dart';

import 'custom_page.dart';
import 'navigator20/details_screen.dart';
import 'main_screen.dart';

class PageManager extends ChangeNotifier {
  /// it's important to provide new list for Navigator each time
  /// because it compares previous list with the next one on each [NavigatorState didUpdateWidget]
  List<Page> get pages => List.unmodifiable(_pages);
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

  void didPop(Page page) {
    _pages.remove(page);
  }
}
