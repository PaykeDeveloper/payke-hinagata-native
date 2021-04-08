import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:provider/provider.dart';

import './navigators/books.dart';
import './navigators/home.dart';
import './widgets/organisms/main_drawer.dart';
import 'pages/common/loading.dart';

class MainNavigation extends StatelessWidget {
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

  final _children = <Widget>[
    LoadingScreen(),
    LoadingScreen(),
  ];

  Widget _getWidget(BottomTab tab) {
    final index = tab.getIndex();
    switch (tab) {
      case BottomTab.home:
        return HomeNavigator(
          navigatorKey: _navigatorKeys[index],
          scaffoldKey: _scaffoldKey,
        );
      case BottomTab.books:
        return BooksNavigator(
          navigatorKey: _navigatorKeys[index],
          scaffoldKey: _scaffoldKey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = context.select((RouteState state) => state.tab);
    final index = tab.getIndex();
    final isFirst = context.select((RouteState state) => state.isFirstTab);
    if (_children[index] is LoadingScreen) {
      _children[index] = _getWidget(tab);
    }
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

        if (tab != initialTab) {
          context.read<RouteStateNotifier>().changeIndex(initialTab);
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
          onTap: (int index) {
            context
                .read<RouteStateNotifier>()
                .changeIndex(BottomTabExt.getTab(index));
          },
        ),
      ),
    );
  }
}
