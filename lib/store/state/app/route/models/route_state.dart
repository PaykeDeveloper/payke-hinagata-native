import 'package:freezed_annotation/freezed_annotation.dart';

import './route_params.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    required BottomTab tab,
    @Default([]) List<RouteParams> homePages,
    @Default([]) List<RouteParams> projectPages,
    @Default([]) List<RouteParams> memberPages,
  }) = _RouteState;

  const RouteState._();

  bool get isFirstTab {
    switch (tab) {
      case BottomTab.home:
        return homePages.isEmpty;
      case BottomTab.projects:
        return projectPages.isEmpty;
      case BottomTab.members:
        return memberPages.isEmpty;
    }
  }
}

enum BottomTab {
  home,
  projects,
  members,
}

const _tabHome = 0;
const _tabProjects = 1;
const _tabMembers = 2;

extension BottomTabExt on BottomTab {
  int getIndex() {
    switch (this) {
      case BottomTab.home:
        return _tabHome;
      case BottomTab.projects:
        return _tabProjects;
      case BottomTab.members:
        return _tabMembers;
    }
  }

  static BottomTab getTab(int index) {
    switch (index) {
      case _tabHome:
        return BottomTab.home;
      case _tabProjects:
        return BottomTab.projects;
      case _tabMembers:
        return BottomTab.members;
      default:
        throw ArgumentError.value(index);
    }
  }
}
