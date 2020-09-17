import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_transition_delegate.dart';
import 'page_manager.dart';
import 'pages.dart';

void main() {
  final pageManager = PageManager();
  runApp(TheApp(pageManager));
}

class TheApp extends StatelessWidget {
  TheApp(this.pageManager);

  final PageManager pageManager;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pageManager,
      child: MaterialApp(
        title: 'Flutter Navigator Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: NavigatorPage(),
      ),
    );
  }
}

class NavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      // using provider here, but it could be bloc,
      // setState or any other way to notify about the changes
      builder: (context, pageManager, _) {
        if (pageManager.isNavigator2) {
          return Navigator(
            pages: pageManager.pages,
            onPopPage: (route, result) =>
                _onPopPage(route, result, pageManager),

            /// You can provide your own [TransitionDelegate] implementation
            /// to decide if navigation operation should be animated
            ///
            /// Note that it's not specifying the animation itself
            transitionDelegate: const CustomTransitionDelegate(),
          );
        } else {
          return MainPage(isNavigator2: false);
        }
      },
    );
  }

  /// You need to provide `onPopPage` to [Navigator]
  /// to properly clean up `pages` list if a page has been popped.
  bool _onPopPage(
      Route<dynamic> route, dynamic result, PageManager pageManager) {
    pageManager.didPop(route.settings);
    return route.didPop(result);
  }
}
