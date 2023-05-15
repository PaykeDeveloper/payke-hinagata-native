import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/app/route/selectors.dart';
import 'package:native_app/ui/screens/common/home.dart';
import 'package:provider/provider.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({
    super.key,
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _navigatorKey = navigatorKey,
        _scaffoldKey = scaffoldKey;
  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final paramsList = context.select(homeParamsListSelector);
    return Navigator(
      key: _navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        final notifier = context.read<RouteStateNotifier>();
        notifier.pop(BottomTab.home);
        return true;
      },
      pages: [
        HomePage(openDrawer: _openDrawer),
        ...paramsList.map((p) => p.toPage()),
      ],
    );
  }
}
