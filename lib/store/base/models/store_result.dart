import 'package:freezed_annotation/freezed_annotation.dart';

import './store_error.dart';

part 'store_result.freezed.dart';

@freezed
class StoreResult<T> with _$StoreResult<T> {
  const StoreResult._();

  const factory StoreResult.success(T data) = Success<T>;

  const factory StoreResult.failure(StoreError error) = Failure;

  T? getDataOrNull() => when(
        success: (data) => data,
        failure: (error) => null,
      );
}
