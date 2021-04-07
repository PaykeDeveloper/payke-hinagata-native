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

  @override
  void initState() {
    super.initState();
    _children = [
      HomeNavigator(
        navigatorKey: _navigatorKeys[0],
        main: this,
      ),
      BooksNavigator(
        navigatorKey: _navigatorKeys[1],
        main: this,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final index = context.select((RouteState state) => state.tabIndex);
    final isFirst = context.select((RouteState state) => state.isFirstTab());
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
        drawerEnableOpenDragGesture: isFirst,
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
