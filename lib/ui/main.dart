import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/ui/pages/books/list.dart';
import 'package:native_app/ui/pages/common/home.dart';
import 'package:native_app/ui/pages/common/loading.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _getTabWidget(index);
          },
        );
      },
    );
  }

  Widget _getTabWidget(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return BookListPage();
      default:
        return LoadingPage();
    }
  }
}
