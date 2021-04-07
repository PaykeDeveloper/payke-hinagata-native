import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/ui/navigators/books.dart';
import 'package:native_app/ui/navigators/home.dart';
import 'package:provider/provider.dart';

import './utils/main_interface.dart';
import './widgets/organisms/main_drawer.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> implements MainInterface {
  late List<Widget> _children;

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

  void _didNavigate() {
    final index = context.read<RouteState>().tabIndex;
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
    _children = [
      HomeNavigator(
        navigatorKey: _navigatorKeys[0],
        navigatorObservers: [_tabNavigatorObservers[0]],
        main: this,
      ),
      BooksNavigator(
        navigatorKey: _navigatorKeys[1],
        navigatorObservers: [_tabNavigatorObservers[1]],
        main: this,
      )
    ];
    for (final observer in _tabNavigatorObservers) {
      observer.didNavigate = _didNavigate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = context.select((RouteState state) => state.tabIndex);
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
          return false;
        }

        final popped = await _navigatorKeys[index].currentState?.maybePop();
        if (popped == true) {
          return false;
        }

        if (index != 0) {
          context.read<RouteStateNotifier>().changeIndex(0);
          return false;
        }

        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        drawerEnableOpenDragGesture: _isFirsts[index],
        body: IndexedStack(
          index: index,
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          items: _tabItems,
          onTap: (value) =>
              context.read<RouteStateNotifier>().changeIndex(value),
        ),
      ),
    );
  }

  @override
  ScaffoldState? getScaffoldState() => _scaffoldKey.currentState;
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
