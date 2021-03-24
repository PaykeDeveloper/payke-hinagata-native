import 'package:freezed_annotation/freezed_annotation.dart';

import 'state_error.dart';

part 'entity_state.freezed.dart';

@freezed
class EntityState<T> with _$EntityState<T> {
  const factory EntityState(
    T data, {
    @Default(StateStatus.initial) StateStatus status,
    @Default(null) StateError? error,
  }) = _EntityState<T>;
}

enum StateStatus {
  initial,
  started,
  done,
  failed,
}
