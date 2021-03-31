import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/ui/widgets/organisms/main_drawer.dart';

import './pages/books/list.dart';
import './pages/common/home.dart';
import './pages/common/loading.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final _tabController = CupertinoTabController();

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  final _isFirsts = [
    true,
    true,
  ];

  // void _onTabNavigate(int index, bool isFirst) {
  //   final currentValue = _isFirsts[index];
  //   if (currentValue != isFirst) {
  //     setState(() {
  //       _isFirsts[index] = isFirst;
  //     });
  //   }
  // }

  void _onTabNavigate() {
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

  late final List<_TabNavigatorObserver> _tabNavigatorObservers;

  @override
  void initState() {
    super.initState();
    _tabNavigatorObservers = [
      _TabNavigatorObserver((isFirst) => _onTabNavigate()),
      _TabNavigatorObserver((isFirst) => _onTabNavigate()),
    ];
    _tabController.addListener(() {
      debugPrint('aaaaaaaaaaaaaaa');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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

  Widget _getTabWidget(int index) {
    switch (index) {
      case 0:
        return HomePage(onPressedDrawerMenu: _openDrawer);
      case 1:
        return BookListPage(onPressedDrawerMenu: _openDrawer);
      default:
        return LoadingPage();
    }
  }
}

// class _TabData {
//   _TabData({
//     required this.barItem,
//     required this.builder,
//     required this.navigatorKey,
//   });
//
//   final BottomNavigationBarItem barItem;
//   final WidgetBuilder builder;
//   final GlobalKey<NavigatorState> navigatorKey;
// }

class _TabNavigatorObserver extends NavigatorObserver {
  _TabNavigatorObserver(this._didNavigate);

  final Function(bool) _didNavigate;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _didNavigate(route.isFirst);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _didNavigate(previousRoute?.isFirst == true);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  // @override
  // void didStartUserGesture(Route route, Route? previousRoute) {
  //   super.didStartUserGesture(route, previousRoute);
  // }
}
