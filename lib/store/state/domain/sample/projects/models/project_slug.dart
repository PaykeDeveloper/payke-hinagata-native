// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_slug.freezed.dart';

part 'project_slug.g.dart';

@freezed
class ProjectSlug with _$ProjectSlug {
  const factory ProjectSlug(String value) = _ProjectSlug;

  factory ProjectSlug.fromJson(dynamic value) => ProjectSlug(value as String);
}
