import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/ui/pages/common/home.dart';
import 'package:provider/provider.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({
    required GlobalKey<NavigatorState> navigatorKey,
    required ScaffoldState? mainState,
  })   : _navigatorKey = navigatorKey,
        _mainState = mainState;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final ScaffoldState? _mainState;

  @override
  Widget build(BuildContext context) {
    final pages = context.select((RouteState state) => state.homePages);
    return Navigator(
      key: _navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        final notifier = context.read<RouteStateNotifier>();
        notifier.popHomePage();
        return true;
      },
      pages: [HomePage(mainState: _mainState), ...pages],
    );
  }
}
