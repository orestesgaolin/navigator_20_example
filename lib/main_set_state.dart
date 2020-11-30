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
      MaterialPage(
        child: HomePage(
          onAddPage: () {
            pages.add(
              DetailsPage.page(
                onAddPage: () {
                  pages.add(InnerApp.page());
                  setState(() {});
                },
              ),
            );
            setState(() {});
          },
        ),
        key: const Key('HomePage'),
      ),
    );
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
    final didPop = route.didPop(result);
    if (didPop == true) {
      pages.remove(route.settings);
    }
    return didPop;
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
  static Page page({VoidCallback onAddPage}) => MaterialPage(
        child: DetailsPage(onAddPage: onAddPage),
        key: const Key('DetailsPage'),
      );

  const DetailsPage({
    Key key,
    this.onAddPage,
  }) : super(key: key);

  final VoidCallback onAddPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Center(
            child: Text('Details Page'),
          ),
          TextButton(
            child: Text('Add Inner Navigator'),
            onPressed: onAddPage,
          )
        ],
      ),
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
          child: Text('Go to 3rd.'),
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

class InnerApp extends StatefulWidget {
  static Page page() =>
      MaterialPage(child: InnerApp(), key: const Key('InnerApp'));

  @override
  _InnerAppState createState() => _InnerAppState();
}

class _InnerAppState extends State<InnerApp> {
  final pages = <Page>[];
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    pages.add(
      MaterialPage(
        child: InnerHomePage(
          onAddPage: () {
            pages.add(
              MaterialPage(
                child: InnerDetailsPage(),
                key: const Key('InnerDetailsPage'),
              ),
            );
            setState(() {});
          },
        ),
        key: const Key('InnerHomePage'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        pages: List.of(pages),
        onPopPage: _onPopPage,
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (didPop == true) {
      pages.remove(route.settings);
    }
    return didPop;
  }
}

class InnerHomePage extends StatelessWidget {
  const InnerHomePage({Key key, this.onAddPage}) : super(key: key);

  final VoidCallback onAddPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inner Home Page'),
      ),
      body: TextButton(
        child: Text('Add page'),
        onPressed: onAddPage,
      ),
    );
  }
}

class InnerDetailsPage extends StatelessWidget {
  const InnerDetailsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inner Details Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(child: Text('Inner Details Page')),
    );
  }
}
