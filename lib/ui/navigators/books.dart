import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/ui/pages/books/add.dart';
import 'package:native_app/ui/pages/books/detail.dart';
import 'package:native_app/ui/pages/books/edit.dart';
import 'package:native_app/ui/pages/books/list.dart';
import 'package:native_app/ui/utils/main_interface.dart';
import 'package:provider/provider.dart';

class BooksNavigator extends StatelessWidget {
  const BooksNavigator({
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
    final routeState = context.watch<RouteState>();
    final bookDetailId = routeState.bookDetailId;
    final bookEditId = routeState.bookEditId;
    return Navigator(
      key: _navigatorKey,
      observers: _navigatorObservers ?? [],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        final notifier = context.read<RouteStateNotifier>();
        if (routeState.bookNew) {
          notifier.removeBookNew();
        } else if (bookEditId != null) {
          notifier.removeBookEdit();
        } else if (bookDetailId != null) {
          notifier.removeBookDetail();
        }
        return true;
      },
      pages: [
        MaterialPage(
          key: const ValueKey('BookListScreen'),
          child: BookListScreen(main: _main),
        ),
        if (bookDetailId != null) BookDetailPage(bookId: bookDetailId),
        if (bookEditId != null) BookEditPage(bookId: bookEditId),
        if (routeState.bookNew) BookAddPage(),
      ],
    );
  }
}
