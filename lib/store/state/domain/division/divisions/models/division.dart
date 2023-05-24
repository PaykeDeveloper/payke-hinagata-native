// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import './division_id.dart';

part 'division.freezed.dart';
part 'division.g.dart';

@freezed
class Division with _$Division {
  const factory Division({
    required DivisionId id,
    required String name,
    required DateTime createdAt,
  }) = _Division;

  factory Division.fromJson(Map<String, dynamic> json) =>
      _$DivisionFromJson(json);
}
