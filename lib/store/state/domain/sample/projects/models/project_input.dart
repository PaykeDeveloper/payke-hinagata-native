// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'project_input.freezed.dart';

part 'project_input.g.dart';

@freezed
class ProjectInput extends JsonGenerator with _$ProjectInput {
  const factory ProjectInput({
    required String name,
  }) = _ProjectInput;

  factory ProjectInput.fromJson(Map<String, dynamic> json) =>
      _$ProjectInputFromJson(json);
}
