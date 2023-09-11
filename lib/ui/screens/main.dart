import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    return _Main(
      onTap: onTap,
      changeTab: changeTab,
      tab: tab,
      isFirst: isFirst,
    );
  }
}

class _Main extends HookWidget {
  const _Main({
    required this.onTap,
    required this.changeTab,
    required this.tab,
    required this.isFirst,
  });

  final Function1<int, void> onTap;
  final Function1<BottomTab, Future> changeTab;
  final BottomTab tab;
  final bool isFirst;

  Widget _getWidget(
    BottomTab tab,
    GlobalKey<ScaffoldState> scaffoldKey,
    List<GlobalKey<NavigatorState>> navigatorKeys,
  ) {
    final index = tab.getIndex();
    switch (tab) {
      case BottomTab.home:
        return HomeNavigator(
          navigatorKey: navigatorKeys[index],
          scaffoldKey: scaffoldKey,
        );
      case BottomTab.projects:
        return ProjectsNavigator(
          navigatorKey: navigatorKeys[index],
          scaffoldKey: scaffoldKey,
        );
      case BottomTab.members:
        return MembersNavigator(
          navigatorKey: navigatorKeys[index],
          scaffoldKey: scaffoldKey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    final navigatorKeys = useMemoized(() => [
          GlobalKey<NavigatorState>(),
          GlobalKey<NavigatorState>(),
          GlobalKey<NavigatorState>(),
        ]);

    final children = useMemoized<List<Widget>>(() => [
          const LoadingScreen(),
          const LoadingScreen(),
          const LoadingScreen(),
        ]);

    final index = tab.getIndex();
    if (children[index] is LoadingScreen) {
      children[index] = _getWidget(tab, scaffoldKey, navigatorKeys);
    }
    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
          return false;
        }

        final popped = await navigatorKeys[index].currentState?.maybePop();
        if (popped == true) {
          return false;
        }

        if (tab != initialTab) {
          await changeTab(initialTab);
          return false;
        }

        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: const MainDrawer(),
        drawerEnableOpenDragGesture: isFirst,
        body: IndexedStack(
          index: index,
          children: children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Members',
            ),
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}
