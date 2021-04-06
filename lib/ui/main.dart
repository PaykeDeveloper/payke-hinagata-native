import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/ui/pages/books/detail.dart';

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

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void openBooks() {
    const index = 1;
    _tabController.index = index;
    _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
  }

  @override
  void openBook(BookId bookId) {
    const index = 1;
    _tabController.index = index;
    _navigatorKeys[index].currentState?.pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return BookDetailPage(bookId);
        },
      ),
      (route) => route.isFirst,
    );
  }

  final _isFirsts = [
    true,
    true,
  ];

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
      _TabNavigatorObserver(_onTabNavigate),
      _TabNavigatorObserver(_onTabNavigate),
    ];
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
        return HomePage(main: this);
      case 1:
        return BookListPage(main: this);
      default:
        return LoadingPage();
    }
  }
}

class _TabNavigatorObserver extends NavigatorObserver {
  _TabNavigatorObserver(this._didNavigate);

  final Function() _didNavigate;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _didNavigate();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _didNavigate();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _didNavigate();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _didNavigate();
  }
}
