import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'login_input.freezed.dart';

part 'login_input.g.dart';

@freezed
class LoginInput with _$LoginInput, JsonGenerator {
  const factory LoginInput({required String email, required String password}) =
      _LoginInput;

  factory LoginInput.fromJson(Map<String, dynamic> json) =>
      _$LoginInputFromJson(json);
}
