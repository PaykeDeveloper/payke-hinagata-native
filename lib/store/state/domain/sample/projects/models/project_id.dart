// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_id.freezed.dart';
part 'project_id.g.dart';

@freezed
class ProjectId with _$ProjectId {
  const factory ProjectId(int value) = _ProjectId;

  factory ProjectId.fromJson(dynamic value) => ProjectId(value as int);
}
