import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'login_input.freezed.dart';
part 'login_input.g.dart';

@freezed
class LoginInput with _$LoginInput implements JsonGenerator {
  const factory LoginInput({
    required String email,
    required String password,
    @JsonKey(name: 'package_name') required String packageName,
    @JsonKey(name: 'platform_type') required String platformType,
    @JsonKey(name: 'device_id') String? deviceId,
  }) = _LoginInput;

  factory LoginInput.fromJson(Map<String, dynamic> json) =>
      _$LoginInputFromJson(json);
}
