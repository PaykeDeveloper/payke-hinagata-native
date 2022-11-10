import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

import './models/route_params.dart';
import './models/route_state.dart';

const initialTab = BottomTab.home;

class RouteStateNotifier extends StateNotifier<RouteState> with LocatorMixin {
  RouteStateNotifier() : super(const RouteState(tab: initialTab));

  @override
  void update(Locator watch) {
    super.update(watch);
    final token = watch<BackendTokenState>().data;
    if (token == null) {
      _resetAll();
    }
  }

  Future changeIndex(BottomTab tab) async {
    state = state.copyWith(
      tab: tab,
    );
  }

  Future push(BottomTab tab, RouteParams params) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homeParamsList: [...state.homeParamsList, params],
        );
        break;
      case BottomTab.projects:
        state = state.copyWith(
          projectParamsList: [...state.projectParamsList, params],
        );
        break;
      case BottomTab.members:
        state = state.copyWith(
          memberParamsList: [...state.memberParamsList, params],
        );
        break;
    }
  }

  Future pop(BottomTab tab) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homeParamsList: state.homeParamsList.toList()..removeLast(),
        );
        break;
      case BottomTab.projects:
        state = state.copyWith(
          projectParamsList: state.projectParamsList.toList()..removeLast(),
        );
        break;
      case BottomTab.members:
        state = state.copyWith(
          memberParamsList: state.memberParamsList.toList()..removeLast(),
        );
        break;
    }
  }

  Future replace(BottomTab tab, List<RouteParams> paramsList) async {
    switch (tab) {
      case BottomTab.home:
        state = state.copyWith(
          homeParamsList: paramsList,
        );
        break;
      case BottomTab.projects:
        state = state.copyWith(
          projectParamsList: paramsList,
        );
        break;
      case BottomTab.members:
        state = state.copyWith(
          memberParamsList: paramsList,
        );
        break;
    }
  }

  Future _resetAll() async {
    for (final tab in BottomTab.values) {
      await _reset(tab);
    }
  }

  Future _reset(BottomTab tab) async {
    if (_get(tab).isNotEmpty) {
      await replace(tab, []);
    }
  }

  List<RouteParams> _get(BottomTab tab) {
    switch (tab) {
      case BottomTab.home:
        return state.homeParamsList;
      case BottomTab.projects:
        return state.projectParamsList;
      case BottomTab.members:
        return state.memberParamsList;
    }
  }
}
