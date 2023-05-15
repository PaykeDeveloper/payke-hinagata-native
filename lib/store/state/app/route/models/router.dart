import 'package:freezed_annotation/freezed_annotation.dart';

import './route_params.dart';

part 'router.freezed.dart';

@freezed
class Router with _$Router {
  const factory Router({
    required BottomTab tab,
    @Default([]) List<RouteParams> homeParamsList,
    @Default([]) List<RouteParams> projectParamsList,
    @Default([]) List<RouteParams> memberParamsList,
  }) = _Router;

  const Router._();

  bool get isFirstTab {
    switch (tab) {
      case BottomTab.home:
        return homeParamsList.isEmpty;
      case BottomTab.projects:
        return projectParamsList.isEmpty;
      case BottomTab.members:
        return memberParamsList.isEmpty;
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
