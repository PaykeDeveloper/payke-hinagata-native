// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import './project_slug.dart';

part 'project_url.freezed.dart';

@freezed
class ProjectUrl with _$ProjectUrl {
  const factory ProjectUrl({
    required ProjectSlug slug,
  }) = _ProjectUrl;
}
