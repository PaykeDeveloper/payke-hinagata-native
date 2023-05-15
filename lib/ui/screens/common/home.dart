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

    return Home(
      openDrawer: _openDrawer,
      onPressedProjectList: onPressedProjectList,
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
    required VoidCallback openDrawer,
    required Function0<Future> onPressedProjectList,
  })  : _openDrawer = openDrawer,
        _onPressedProjectList = onPressedProjectList;

  final VoidCallback _openDrawer;
  final Function0<Future> _onPressedProjectList;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._openDrawer,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: widget._onPressedProjectList,
              child: const Text('Project list'),
            ),
          ],
        ),
      ),
    );
  }
}
