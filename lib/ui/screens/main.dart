import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/app/route/selectors.dart';
import 'package:native_app/ui/navigation/navigators/home.dart';
import 'package:native_app/ui/navigation/navigators/members.dart';
import 'package:native_app/ui/navigation/navigators/projects.dart';
import 'package:native_app/ui/widgets/organisms/main_drawer.dart';

import './common/loading.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(int index) {
      final tab = BottomTabExt.getTab(index);
      final notifier = ref.read(routeStateProvider.notifier);
      if (tab != ref.read(routeStateProvider).tab) {
        notifier.changeIndex(tab);
      } else {
        notifier.replace(tab, []);
      }
    }

    Future changeTab(BottomTab tab) async {
      await ref.read(routeStateProvider.notifier).changeIndex(initialTab);
    }

    final tab = ref.watch(tabSelector);
    final isFirst = ref.watch(isFirstTabSelector);

    return Main(
      onTap: onTap,
      changeTab: changeTab,
      tab: tab,
      isFirst: isFirst,
    );
  }
}

class Main extends StatelessWidget {
  Main({
    super.key,
    required Function1<int, void> onTap,
    required Function1<BottomTab, Future> changeTab,
    required BottomTab tab,
    required bool isFirst,
  })  : _onTap = onTap,
        _changeTab = changeTab,
        _tab = tab,
        _isFirst = isFirst;

  final Function1<int, void> _onTap;
  final Function1<BottomTab, Future> _changeTab;
  final BottomTab _tab;
  final bool _isFirst;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
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
      label: 'Projects',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Members',
    ),
  ];

  final _children = <Widget>[
    const LoadingScreen(),
    const LoadingScreen(),
    const LoadingScreen(),
  ];

  Widget _getWidget(BottomTab tab) {
    final index = tab.getIndex();
    switch (tab) {
      case BottomTab.home:
        return HomeNavigator(
          navigatorKey: _navigatorKeys[index],
          scaffoldKey: _scaffoldKey,
        );
      case BottomTab.projects:
        return ProjectsNavigator(
          navigatorKey: _navigatorKeys[index],
          scaffoldKey: _scaffoldKey,
        );
      case BottomTab.members:
        return MembersNavigator(
          navigatorKey: _navigatorKeys[index],
          scaffoldKey: _scaffoldKey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = _tab.getIndex();
    if (_children[index] is LoadingScreen) {
      _children[index] = _getWidget(_tab);
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

        if (_tab != initialTab) {
          await _changeTab(initialTab);
          return false;
        }

        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const MainDrawer(),
        drawerEnableOpenDragGesture: _isFirst,
        body: IndexedStack(
          index: index,
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          items: _tabItems,
          onTap: _onTap,
        ),
      ),
    );
  }
}
