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

  Future pushHomePage(Page page) async {
    state = state.copyWith(
      homePages: [...state.homePages, page],
    );
  }

  Future popHomePage() async {
    state = state.copyWith(
      homePages: state.homePages.toList()..removeLast(),
    );
  }

  Future replaceHomePages(List<Page> pages) async {
    state = state.copyWith(
      homePages: pages,
    );
  }

  Future pushBookPage(Page page) async {
    state = state.copyWith(
      bookPages: [...state.bookPages, page],
    );
  }

  Future popBookPage() async {
    state = state.copyWith(
      bookPages: state.bookPages.toList()..removeLast(),
    );
  }

  Future replaceBookPages(List<Page> pages) async {
    state = state.copyWith(
      bookPages: pages,
    );
  }
}
