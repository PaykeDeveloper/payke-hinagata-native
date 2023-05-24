// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

part 'division_id.freezed.dart';
part 'division_id.g.dart';

@freezed
class DivisionId with _$DivisionId {
  const factory DivisionId(int value) = _DivisionId;

  factory DivisionId.fromJson(dynamic value) => DivisionId(value as int);
}

class DivisionIdConverter implements JsonConverter<DivisionId, int> {
  const DivisionIdConverter();

  @override
  DivisionId fromJson(int json) => DivisionId(json);

  @override
  int toJson(DivisionId object) => object.value;
}
