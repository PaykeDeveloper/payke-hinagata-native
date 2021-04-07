import 'package:flutter/material.dart';
import 'package:native_app/ui/pages/common/home.dart';
import 'package:native_app/ui/utils/main_interface.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({
    GlobalKey<NavigatorState>? navigatorKey,
    required MainInterface main,
  })   : _navigatorKey = navigatorKey,
        _main = main;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final MainInterface _main;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
      pages: [HomePage(key: const ValueKey('HomePage'), main: _main)],
    );
  }
}
