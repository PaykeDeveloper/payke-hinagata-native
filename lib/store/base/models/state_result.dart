import 'package:freezed_annotation/freezed_annotation.dart';

import './state_error.dart';

part 'state_result.freezed.dart';

@freezed
class StateResult<T> with _$StateResult<T> {
  const StateResult._();

  const factory StateResult.success(T data) = Success<T>;

  const factory StateResult.failure(StateError error) = Failure<T>;

  T? getDataOrNull() => when(
        success: (data) => data,
        failure: (error) => null,
      );
}
