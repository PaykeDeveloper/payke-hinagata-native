import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/token.dart';

part 'login_output.freezed.dart';

part 'login_output.g.dart';

@freezed
class LoginOutput with _$LoginOutput {
  const factory LoginOutput({
    required Token token,
  }) = _LoginOutput;

  factory LoginOutput.fromJson(Map<String, dynamic> json) =>
      _$LoginOutputFromJson(json);
}
