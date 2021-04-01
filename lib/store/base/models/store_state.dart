import 'package:freezed_annotation/freezed_annotation.dart';

import './store_error.dart';

part 'store_state.freezed.dart';

@freezed
class StoreState<T> with _$StoreState<T> {
  const factory StoreState(
    T data, {
    @Default(StateStatus.initial) StateStatus status,
    @Default(null) StoreError? error,
  }) = _StoreState<T>;
}

enum StateStatus {
  initial,
  started,
  done,
  failed,
}
