// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

part 'book_input.freezed.dart';

part 'book_input.g.dart';

@freezed
class BookInput extends JsonGenerator with _$BookInput {
  const factory BookInput({
    required String title,
    String? author,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
  }) = _BookInput;

  factory BookInput.fromJson(Map<String, dynamic> json) =>
      _$BookInputFromJson(json);
}
