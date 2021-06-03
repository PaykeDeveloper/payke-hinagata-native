// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

import './project_slug.dart';

part 'project_url.freezed.dart';

@freezed
class ProjectUrl with _$ProjectUrl {
  const factory ProjectUrl({
    required DivisionId divisionId,
    required ProjectSlug slug,
  }) = _ProjectUrl;
}
