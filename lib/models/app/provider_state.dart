import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_state.freezed.dart';

@freezed
class ProviderState<T> with _$ProviderState<T> {
  const factory ProviderState(
    T data, {
    @Default(StateStatus.initial) StateStatus status,
  }) = _ProviderState<T>;
}

enum StateStatus {
  initial,
  started,
  done,
  failed,
}
