import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'transition_delegates/custom_transition_delegate.dart';
import 'page_manager.dart';

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
        home: Stack(
          children: [
            MainNavigatorPage(),
            _NavStateLabel(),
          ],
        ),
      ),
    );
  }
}

class _NavStateLabel extends StatelessWidget {
  const _NavStateLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Consumer<PageManager>(
        builder: (context, pageManager, _) {
          return Material(
            elevation: 2,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(pageManager.pages.map((e) => '${e.name}').join('/')),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MainNavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      // using provider here, but it could be bloc,
      // setState or any other way to notify about the changes
      builder: (context, pageManager, _) {
        // This is required to handle back button on Android
        // The same navigator key must be used to check WillPopScope's condition
        // and provided to Navigator widget
        return WillPopScope(
          onWillPop: () async =>
              !await pageManager.navigatorKey.currentState.maybePop(),
          child: Navigator(
            key: pageManager.navigatorKey,
            pages: pageManager.pages,
            onPopPage: (route, result) =>
                _onPopPage(route, result, pageManager),

            /// You can provide your own [TransitionDelegate] implementation
            /// to decide if navigation operation should be animated
            ///
            /// Note that it's not specifying the animation itself
            transitionDelegate: const CustomTransitionDelegate(),
          ),
        );
      },
    );
  }

  /// You need to provide `onPopPage` to [Navigator]
  /// to properly clean up `pages` list if a page has been popped.
  bool _onPopPage(
      Route<dynamic> route, dynamic result, PageManager pageManager) {
    pageManager.didPop(route.settings, result);
    return route.didPop(result);
  }
}
