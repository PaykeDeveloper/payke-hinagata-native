import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:state_notifier/state_notifier.dart';

import './models/route_state.dart';

const initialTab = BottomTab.home;

class RouteStateNotifier extends StateNotifier<RouteState> with LocatorMixin {
  RouteStateNotifier() : super(const RouteState(tab: initialTab));

  Future changeIndex(BottomTab tab) async {
    state = state.copyWith(
      tab: tab,
    );
  }

  Future push(BottomTab tab, Page page) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homePages: [...state.homePages, page],
        );
        break;
      case BottomTab.books:
        state = state.copyWith(
          bookPages: [...state.bookPages, page],
        );
        break;
    }
  }

  Future pop(BottomTab tab) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homePages: state.homePages.toList()..removeLast(),
        );
        break;
      case BottomTab.books:
        state = state.copyWith(
          bookPages: state.bookPages.toList()..removeLast(),
        );
        break;
    }
  }

  Future replace(BottomTab tab, List<Page> pages) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homePages: pages,
        );
        break;
      case BottomTab.books:
        state = state.copyWith(
          bookPages: pages,
        );
        break;
    }
  }
}
