import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/ui/pages/books/list.dart';
import 'package:provider/provider.dart';

class BooksNavigator extends StatelessWidget {
  const BooksNavigator({
    required GlobalKey<NavigatorState>? navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })   : _navigatorKey = navigatorKey,
        _scaffoldKey = scaffoldKey;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

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
        notifier.pop(BottomTab.books);
        return true;
      },
      pages: [BookListPage(openDrawer: _openDrawer), ...pages],
    );
  }
}
