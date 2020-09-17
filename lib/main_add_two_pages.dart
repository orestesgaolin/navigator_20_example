import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatefulWidget {
  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  final pages = <Page>[];

  @override
  void initState() {
    super.initState();
    pages.addAll(<Page>[
      MyCustomPage(
        builder: (_) => HomePage(
          addTwoPages: addTwoPages,
        ),
        key: const Key('HomePage'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Navigator(
        pages: List.unmodifiable(pages),
        onPopPage: _onPopPage,
        // transitionDelegate: NoAnimationTransitionDelegate(),
      ),
    );
  }

  void addTwoPages() {
    pages.addAll([
      MyCustomPage(
        builder: (_) => SecondLevelPage(),
        key: const Key('SecondLevelPage'),
      ),
      MyCustomPage(
        builder: (_) => ThirdLevelPage(),
        key: const Key('ThirdLevelPage'),
      ),
    ]);
    setState(() {});
  }

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
  const HomePage({Key key, this.addTwoPages}) : super(key: key);

  final VoidCallback addTwoPages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: addTwoPages,
          child: Text('Add two more pages'),
        ),
      ),
    );
  }
}

class SecondLevelPage extends StatelessWidget {
  const SecondLevelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecondLevel'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class ThirdLevelPage extends StatefulWidget {
  const ThirdLevelPage({
    Key key,
  }) : super(key: key);

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => increment(),
        child: Text('$counter'),
      ),
    );
  }
}
