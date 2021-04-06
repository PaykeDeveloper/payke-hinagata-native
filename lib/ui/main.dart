import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './pages/books/list.dart';
import './pages/common/home.dart';
import './pages/common/loading.dart';
import './utils/main_interface.dart';
import './widgets/organisms/main_drawer.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> implements MainInterface {
  final _tabController = CupertinoTabController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final _tabNavigatorObservers = [
    _TabNavigatorObserver(),
    _TabNavigatorObserver(),
  ];

  final _isFirsts = [
    true,
    true,
  ];

  final _tabItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Books',
    ),
  ];

  Widget _getTabWidget(int index) {
    switch (index) {
      case 0:
        return HomePage(main: this);
      case 1:
        return BookListPage(main: this);
      default:
        return LoadingPage();
    }
  }

  int _getIndexFromTab(BottomTab tab) {
    switch (tab) {
      case BottomTab.home:
        return 0;
      case BottomTab.books:
        return 1;
    }
  }

  void _didNavigate() {
    final index = _tabController.index;
    final canPop = _navigatorKeys[index].currentState?.canPop();
    final isFirst = canPop == false;
    final currentValue = _isFirsts[index];
    if (currentValue != isFirst) {
      setState(() {
        _isFirsts[index] = isFirst;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    for (final observer in _tabNavigatorObservers) {
      observer.didNavigate = _didNavigate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
          return false;
        }

        final popped =
            await _navigatorKeys[_tabController.index].currentState?.maybePop();
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
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        drawerEnableOpenDragGesture: _isFirsts[_tabController.index],
        body: CupertinoTabScaffold(
          controller: _tabController,
          tabBar: CupertinoTabBar(
            items: _tabItems,
          ),
          tabBuilder: (BuildContext context, int index) {
            return CupertinoTabView(
              navigatorObservers: [_tabNavigatorObservers[index]],
              navigatorKey: _navigatorKeys[index],
              builder: (BuildContext context) {
                return _getTabWidget(index);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  ScaffoldState? getScaffoldState() => _scaffoldKey.currentState;

  @override
  NavigatorState? getNavigatorState(BottomTab tab) {
    final index = _getIndexFromTab(tab);
    if (_tabController.index != index) {
      _tabController.index = index;
    }
    return _navigatorKeys[index].currentState;
  }
}

class _TabNavigatorObserver extends NavigatorObserver {
  // ignore: prefer_function_declarations_over_variables
  VoidCallback didNavigate = () {};

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    didNavigate();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    didNavigate();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    didNavigate();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    didNavigate();
  }
}
