import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    required BottomTab tab,
    @Default([]) List<Page> homePages,
    @Default([]) List<Page> projectPages,
  }) = _RouteState;

  const RouteState._();

  bool get isFirstTab {
    switch (tab) {
      case BottomTab.home:
        return homePages.isEmpty;
      case BottomTab.projects:
        return projectPages.isEmpty;
    }
  }
}

enum BottomTab {
  home,
  projects,
}

const _tabHome = 0;
const _tabProjects = 1;

extension BottomTabExt on BottomTab {
  int getIndex() {
    switch (this) {
      case BottomTab.home:
        return _tabHome;
      case BottomTab.projects:
        return _tabProjects;
    }
  }

  static BottomTab getTab(int index) {
    switch (index) {
      case _tabHome:
        return BottomTab.home;
      case _tabProjects:
        return BottomTab.projects;
      default:
        throw ArgumentError.value(index);
    }
  }
}
