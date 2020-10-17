import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigator10/navigator_page.dart';
import 'navigator20/navigator_page.dart';
import 'screens/about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  void _setPage(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Navigator 2.0',
            icon: Icon(CupertinoIcons.square_stack_3d_up),
          ),
          BottomNavigationBarItem(
            label: 'Navigator',
            icon: Icon(CupertinoIcons.perspective),
          ),
          BottomNavigationBarItem(
            label: 'About',
            icon: Icon(CupertinoIcons.star_slash),
          ),
        ],
        onTap: _setPage,
        currentIndex: _index,
      ),
      body: IndexedStack(
        index: _index,
        children: [
          Navigator20Screen(),
          Navigator10Screen(),
          AboutScreen(),
        ],
      ),
    );
  }
}
