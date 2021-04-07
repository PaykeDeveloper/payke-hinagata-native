import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/ui/pages/books/detail.dart';

abstract class MainInterface {
  ScaffoldState? getScaffoldState();

  NavigatorState? getNavigatorState(BottomTab tab);
}

enum BottomTab {
  home,
  books,
}

extension MainInterfaceExt on MainInterface {
  void openDrawer() => getScaffoldState()?.openDrawer();
}

extension BookInterfaceExt on MainInterface {
  void openBooks() =>
      getNavigatorState(BottomTab.books)?.popUntil((route) => route.isFirst);

  Future openBookDetail({required BookId bookId}) async =>
      await getNavigatorState(BottomTab.books)?.pushAndRemoveUntil(
        BookDetailPage.getRoute(bookId: bookId),
        (route) => route.isFirst,
      );
}
