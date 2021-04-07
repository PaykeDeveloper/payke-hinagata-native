import 'package:flutter/material.dart';
import 'package:native_app/ui/pages/common/home.dart';
import 'package:native_app/ui/utils/main_interface.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({
    GlobalKey<NavigatorState>? navigatorKey,
    List<NavigatorObserver>? navigatorObservers,
    required MainInterface main,
  })   : _navigatorKey = navigatorKey,
        _navigatorObservers = navigatorObservers,
        _main = main;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final List<NavigatorObserver>? _navigatorObservers;
  final MainInterface _main;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      observers: _navigatorObservers ?? [],
      pages: [HomePage(main: _main)],
    );
  }
}
