import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/base/api/exception.dart';

import 'exception.dart';

part 'result.freezed.dart';

@freezed
class ApiResult<T> with _$ApiResult<T> {
  const ApiResult._();

  const factory ApiResult.success(T data) = Success<T>;

  const factory ApiResult.failure(ApiException exception) = Failure<T>;

  T? getDataOrNull() => when(
        success: (data) => data,
        failure: (exception) => null,
      );
}
