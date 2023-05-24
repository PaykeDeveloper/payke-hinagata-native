// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'member_input.freezed.dart';
part 'member_input.g.dart';

@freezed
class MemberInput with _$MemberInput implements JsonGenerator {
  const factory MemberInput({
    required int userId,
    required List<String> roleNames,
  }) = _MemberInput;

  factory MemberInput.fromJson(Map<String, dynamic> json) =>
      _$MemberInputFromJson(json);
}
