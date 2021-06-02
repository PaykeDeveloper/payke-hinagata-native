// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';

import './project_id.dart';

part 'project.freezed.dart';

part 'project.g.dart';

enum Priority {
  @JsonValue('high')
  high,
  @JsonValue('middle')
  middle,
  @JsonValue('low')
  low,
}

@freezed
class Project with _$Project {
  const factory Project({
    required ProjectId id,
    @JsonKey(name: 'division_id') required DivisionId divisionId,
    required ProjectSlug slug,
    required String name,
    required String description,
    Priority? priority,
    bool? approved,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'finished_at') DateTime? finishedAt,
    int? difficulty,
    double? coefficient,
    double? productivity,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'lock_version') int? lockVersion,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
