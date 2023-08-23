import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';

class HomePage extends Page {
  const HomePage({
    required VoidCallback openDrawer,
  }) : _openDrawer = openDrawer;
  final VoidCallback _openDrawer;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => HomeScreen(openDrawer: _openDrawer),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    required VoidCallback openDrawer,
  }) : _openDrawer = openDrawer;
  final VoidCallback _openDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future onPressedProjectList() async {
      final notifier = ref.read(routeStateProvider.notifier);
      await notifier.changeIndex(BottomTab.projects);
      await notifier.replace(BottomTab.projects, []);
    }

    return _Home(
      openDrawer: _openDrawer,
      onPressedProjectList: onPressedProjectList,
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({
    required this.openDrawer,
    required this.onPressedProjectList,
  });

  final VoidCallback openDrawer;
  final Function0<Future> onPressedProjectList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onPressedProjectList,
              child: const Text('Project list'),
            ),
          ],
        ),
      ),
    );
  }
}
