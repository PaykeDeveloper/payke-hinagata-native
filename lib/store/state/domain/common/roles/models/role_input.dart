import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'role_input.freezed.dart';
part 'role_input.g.dart';

@freezed
class RoleInput extends JsonGenerator with _$RoleInput {
  const factory RoleInput({
    required String name,
  }) = _RoleInput;

  factory RoleInput.fromJson(Map<String, dynamic> json) =>
      _$RoleInputFromJson(json);
}
