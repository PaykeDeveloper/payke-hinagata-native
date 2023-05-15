// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/app/route/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/screens/sample/projects/list.dart';
import 'package:provider/provider.dart';

class ProjectsNavigator extends StatelessWidget {
  const ProjectsNavigator({
    super.key,
    required GlobalKey<NavigatorState>? navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _navigatorKey = navigatorKey,
        _scaffoldKey = scaffoldKey;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final paramsList = context.select(projectParamsListSelector);
    final divisionId = context.select(divisionIdSelector);
    return Navigator(
      key: _navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        final notifier = context.read<RouteStateNotifier>();
        notifier.pop(BottomTab.projects);
        return true;
      },
      pages: [
        ProjectListPage(divisionId: divisionId!, openDrawer: _openDrawer),
        ...paramsList.map((p) => p.toPage()),
      ],
    );
  }
}
