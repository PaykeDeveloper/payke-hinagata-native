import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/base/api/exception.dart';

part 'provider_state.freezed.dart';

@freezed
class ProviderState<T> with _$ProviderState<T> {
  const factory ProviderState(
    T data, {
    @Default(StateStatus.initial) StateStatus status,
    @Default(null) ApiException? error,
  }) = _ProviderState<T>;
}

enum StateStatus {
  initial,
  started,
  done,
  failed,
}
