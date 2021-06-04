// FIXME: SAMPLE CODE
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

import './priority.dart';

part 'project_input.freezed.dart';

part 'project_input.g.dart';

@freezed
class ProjectInput extends JsonGenerator with _$ProjectInput {
  const factory ProjectInput({
    String? name,
    String? description,
    Priority? priority,
    bool? approved,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'finished_at') DateTime? finishedAt,
    int? difficulty,
    double? coefficient,
    double? productivity,
    @JsonKey(ignore: true) File? cover,
    @JsonKey(name: 'lock_version') int? lockVersion,
  }) = _ProjectInput;

  factory ProjectInput.fromJson(Map<String, dynamic> json) =>
      _$ProjectInputFromJson(json);
}
