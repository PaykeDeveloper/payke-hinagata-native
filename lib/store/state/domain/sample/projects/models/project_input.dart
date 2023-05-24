// FIXME: SAMPLE CODE
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';

import './priority.dart';

part 'project_input.freezed.dart';

part 'project_input.g.dart';

@freezed
class ProjectInput with _$ProjectInput implements JsonGenerator {
  const factory ProjectInput({
    String? name,
    String? description,
    Priority? priority,
    bool? approved,
    DateTime? startDate,
    DateTime? finishedAt,
    int? difficulty,
    double? coefficient,
    double? productivity,
    @JsonKey(includeFromJson: false, includeToJson: false) File? cover,
    int? lockVersion,
  }) = _ProjectInput;

  factory ProjectInput.fromJson(Map<String, dynamic> json) =>
      _$ProjectInputFromJson(json);
}
