// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

part 'projects_url.freezed.dart';

@freezed
class ProjectsUrl with _$ProjectsUrl {
  const factory ProjectsUrl({
    required DivisionId divisionId,
  }) = _ProjectsUrl;
}
