import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_result.freezed.dart';

part 'error_result.g.dart';

@freezed
class ErrorResult with _$ErrorResult {
  const factory ErrorResult({
    required String message,
    required Map<String, List<String>> errors,
  }) = _ErrorResult;

  factory ErrorResult.fromJson(Map<String, dynamic> json) =>
      _$ErrorResultFromJson(json);
}
