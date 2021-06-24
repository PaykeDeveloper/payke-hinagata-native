import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'user_input.freezed.dart';

part 'user_input.g.dart';

@freezed
class UserInput extends JsonGenerator with _$UserInput {
  const factory UserInput({
    required String name,
  }) = _UserInput;

  factory UserInput.fromJson(Map<String, dynamic> json) =>
      _$UserInputFromJson(json);
}
