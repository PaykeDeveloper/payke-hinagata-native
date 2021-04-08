import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/ui/pages/books/list.dart';
import 'package:provider/provider.dart';

class BooksNavigator extends StatelessWidget {
  const BooksNavigator({
    required GlobalKey<NavigatorState>? navigatorKey,
    required ScaffoldState? mainState,
  })   : _navigatorKey = navigatorKey,
        _mainState = mainState;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final ScaffoldState? _mainState;

  @override
  Widget build(BuildContext context) {
    final pages = context.select((RouteState state) => state.bookPages);
    return Navigator(
      key: _navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        final notifier = context.read<RouteStateNotifier>();
        notifier.popBookPage();
        return true;
      },
      pages: [BookListPage(mainState: _mainState), ...pages],
    );
  }
}
