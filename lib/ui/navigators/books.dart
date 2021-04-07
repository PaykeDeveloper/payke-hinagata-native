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
    required MainInterface main,
  })   : _navigatorKey = navigatorKey,
        _main = main;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final MainInterface _main;

  @override
  Widget build(BuildContext context) {
    final routeState = context.watch<RouteState>();
    final bookDetailId = routeState.bookDetailId;
    final bookEditId = routeState.bookEditId;
    return Navigator(
      key: _navigatorKey,
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
        BookListPage(key: const ValueKey('BookListPage'), main: _main),
        if (bookDetailId != null)
          BookDetailPage(
            key: ValueKey('BookDetailPage-${bookDetailId.value}'),
            bookId: bookDetailId,
          ),
        if (bookEditId != null)
          BookEditPage(
            key: ValueKey('BookEditPage-${bookEditId.value}'),
            bookId: bookEditId,
          ),
        if (routeState.bookNew) const BookAddPage(key: ValueKey('BookAddPage')),
      ],
    );
  }
}
