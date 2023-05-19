import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/backend_token.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class BackendTokenState extends _$BackendTokenState {
  @override
  StoreState<BackendToken?> build() => const StoreState(null);

  Future initialize() async {
    state = state.copyWith(status: StateStatus.started);

    final value = await backendToken.get();
    final data = value != null ? BackendToken(value) : null;
    state = state.copyWith(data: data, status: StateStatus.done);
  }

  Future<bool> setToken(BackendToken data) async {
    final result = await backendToken.set(data.value);
    state = state.copyWith(data: data, status: StateStatus.done);
    return result;
  }

  Future<bool?> removeToken() async {
    final result = await backendToken.remove();
    state = state.copyWith(data: null, status: StateStatus.done);
    return result;
  }
}
