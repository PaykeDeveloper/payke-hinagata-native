// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'member_input.freezed.dart';
part 'member_input.g.dart';

@freezed
class MemberInput extends JsonGenerator with _$MemberInput {
  const factory MemberInput({
    @JsonKey(name: "user_id") required int userId,
    @JsonKey(name: 'role_names') required List<String> roleNames,
  }) = _MemberInput;

  factory MemberInput.fromJson(Map<String, dynamic> json) =>
      _$MemberInputFromJson(json);
}
