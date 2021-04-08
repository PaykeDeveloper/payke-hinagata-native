import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const RouteState._();

  const factory RouteState({
    required BottomTab tab,
    @Default([]) List<Page> homePages,
    @Default([]) List<Page> bookPages,
  }) = _RouteState;

  bool get isFirstTab {
    switch (tab) {
      case BottomTab.home:
        return homePages.isEmpty;
      case BottomTab.books:
        return bookPages.isEmpty;
    }
  }
}

enum BottomTab {
  home,
  books,
}

const _tabHome = 0;
const _tabBooks = 1;

extension BottomTabExt on BottomTab {
  int getIndex() {
    switch (this) {
      case BottomTab.home:
        return _tabHome;
      case BottomTab.books:
        return _tabBooks;
    }
  }

  static BottomTab getTab(int index) {
    switch (index) {
      case _tabHome:
        return BottomTab.home;
      case _tabBooks:
        return BottomTab.books;
      default:
        throw ArgumentError.value(index);
    }
  }
}
