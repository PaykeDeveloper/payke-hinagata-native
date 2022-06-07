import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';

part 'login_output.freezed.dart';
part 'login_output.g.dart';

@freezed
class LoginOutput with _$LoginOutput {
  const factory LoginOutput({
    required BackendToken token,
  }) = _LoginOutput;

  factory LoginOutput.fromJson(Map<String, dynamic> json) =>
      _$LoginOutputFromJson(json);
}
