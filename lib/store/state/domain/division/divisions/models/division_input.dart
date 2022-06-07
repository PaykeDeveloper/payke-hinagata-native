// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'division_input.freezed.dart';
part 'division_input.g.dart';

@freezed
class DivisionInput extends JsonGenerator with _$DivisionInput {
  const factory DivisionInput({
    required String name,
  }) = _DivisionInput;

  factory DivisionInput.fromJson(Map<String, dynamic> json) =>
      _$DivisionInputFromJson(json);
}
