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

  Future<List<Page>> push(BottomTab tab, Page page) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homePages: [...state.homePages, page],
        );
        return state.homePages;
      case BottomTab.books:
        state = state.copyWith(
          bookPages: [...state.bookPages, page],
        );
        return state.bookPages;
    }
  }

  Future<List<Page>> pop(BottomTab tab) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homePages: state.homePages.toList()..removeLast(),
        );
        return state.homePages;
      case BottomTab.books:
        state = state.copyWith(
          bookPages: state.bookPages.toList()..removeLast(),
        );
        return state.bookPages;
    }
  }

  Future<List<Page>> replace(BottomTab tab, List<Page> pages) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homePages: pages,
        );
        return state.homePages;
      case BottomTab.books:
        state = state.copyWith(
          bookPages: pages,
        );
        return state.bookPages;
    }
  }
}
