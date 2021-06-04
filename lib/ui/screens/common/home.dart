import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:native_app/ui/screens/sample/projects/detail.dart';
import 'package:native_app/ui/screens/sample/projects/edit.dart';
import 'package:provider/provider.dart';

class HomePage extends Page {
  const HomePage({
    required VoidCallback openDrawer,
  })  : _openDrawer = openDrawer,
        super(key: const ValueKey("homePage"));
  final VoidCallback _openDrawer;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => HomeScreen(openDrawer: _openDrawer),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required VoidCallback openDrawer,
  }) : _openDrawer = openDrawer;

  final VoidCallback _openDrawer;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future _onPressedProjectList() async {
    final notifier = context.read<RouteStateNotifier>();
    await notifier.changeIndex(BottomTab.projects);
    await notifier.replace(BottomTab.projects, []);
  }

  Future _onPressedProjectEdit() async {
    final divisionId = context.read<DivisionIdState>().data;
    if (divisionId == null) return;
    const projectSlug = ProjectSlug('6b42f759-0de1-45dd-bb1d-e82af6207a55');

    final notifier = context.read<RouteStateNotifier>();
    await notifier.changeIndex(BottomTab.projects);
    await notifier.replace(BottomTab.projects, [
      ProjectDetailPage(divisionId: divisionId, projectSlug: projectSlug),
      ProjectEditPage(divisionId: divisionId, projectSlug: projectSlug),
    ]);
  }

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
              onPressed: _onPressedProjectList,
              child: const Text('Project list'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onPressedProjectEdit,
              child: const Text('Project edit'),
            ),
          ],
        ),
      ),
    );
  }
}
