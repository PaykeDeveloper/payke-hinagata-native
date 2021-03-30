import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './pages/books/list.dart';
import './pages/common/home.dart';
import './pages/common/loading.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final _tabController = CupertinoTabController();
  final _navStateKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final popped =
            await _navStateKeys[_tabController.index].currentState?.maybePop();
        if (popped == true) {
          return false;
        }
        if (_tabController.index != 0) {
          setState(() {
            _tabController.index = 0;
          });
          return false;
        }

        return true;
      },
      child: CupertinoTabScaffold(
        controller: _tabController,
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
            navigatorKey: _navStateKeys[index],
            builder: (BuildContext context) {
              return _getTabWidget(index);
            },
          );
        },
      ),
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
