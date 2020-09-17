import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_page.dart';
import 'pages.dart';

class PageManager extends ChangeNotifier {
  bool isNavigator2 = true;

  /// it's important to provide new list for Navigator each time
  /// because it compares previous list with the next one on each [NavigatorState didUpdateWidget]
  List<Page> get pages => List.unmodifiable(_pages);
  final List<Page> _pages = [
    CustomPage(
      builder: (_) => MainPage(),
      key: Key('MainPage'),
    ),
  ];

  static PageManager of(BuildContext context) {
    return Provider.of<PageManager>(context, listen: false);
  }

  void switchNavigatorVersion() {
    isNavigator2 = !isNavigator2;
    notifyListeners();
  }

  void openDetails() {
    _pages.add(
      CustomPage(
        builder: (_) => DetailsPage(),
        key: Key('DetailsPage'),
      ),
    );
    notifyListeners();
  }

  void addOtherPageBeneath() {
    _pages.insert(
      _pages.length - 1,
      CustomPage(
        builder: (_) => OtherPage(),
        key: Key('OtherPage${_pages.length - 1}'),
      ),
    );
    notifyListeners();
  }

  void pushTwoPages() {
    _pages.addAll(
      [
        CustomPage(
          builder: (_) => OtherPage(),
          key: Key('OtherPage'),
        ),
        CustomPage(
          builder: (_) => DetailsPage(),
          key: Key('DetailsPage'),
        ),
      ],
    );
    notifyListeners();
  }

  void makeRootPage() {
    _pages.removeRange(0, _pages.length - 1);
    notifyListeners();
  }

  void replaceTopWithOther() {
    _pages.removeAt(_pages.length - 1);
    _pages.add(
      CustomPage(
        builder: (_) => OtherPage(),
        key: Key('OtherPage'),
      ),
    );
    notifyListeners();
  }

  void didPop(Page page) {
    _pages.remove(page);
  }
}
