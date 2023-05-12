import 'package:native_app/base/preferences.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/backend_token.dart';

part 'notifier.g.dart';

@riverpod
class BackendTokenState extends _$BackendTokenState {
  @override
  StoreState<BackendToken?> build() => const StoreState(null);

  Future initialize() async {
    state = state.copyWith(status: StateStatus.started);

    final value = await Preferences.backendToken.get();
    final token = value != null ? BackendToken(value) : null;
    state = state.copyWith(data: token, status: StateStatus.done);
  }

  Future<bool> setToken(BackendToken token) async {
    final result = await Preferences.backendToken.set(token.value);
    state = state.copyWith(data: token, status: StateStatus.done);
    return result;
  }

  Future<bool?> removeToken() async {
    final result = await Preferences.backendToken.remove();
    state = state.copyWith(data: null, status: StateStatus.done);
    return result;
  }
}
