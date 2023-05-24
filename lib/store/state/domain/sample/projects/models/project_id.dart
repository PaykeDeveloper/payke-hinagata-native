// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_id.freezed.dart';
part 'project_id.g.dart';

@freezed
class ProjectId with _$ProjectId {
  const factory ProjectId(int value) = _ProjectId;

  factory ProjectId.fromJson(dynamic value) => ProjectId(value as int);
}

class ProjectIdConverter implements JsonConverter<ProjectId, int> {
  const ProjectIdConverter();

  @override
  ProjectId fromJson(int json) => ProjectId(json);

  @override
  int toJson(ProjectId object) => object.value;
}
