// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import './project_id.dart';

part 'project.freezed.dart';

part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required ProjectId id,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
