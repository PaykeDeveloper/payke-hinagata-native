import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/ui/screens/sample/projects/detail.dart';

part 'detail.freezed.dart';

@freezed
class ProjectDetailParams with _$ProjectDetailParams implements RouteParams {
  const factory ProjectDetailParams({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  }) = _ProjectDetailParams;

  @override
  Page toPage() => ProjectDetailPage(
        divisionId: divisionId,
        projectSlug: projectSlug,
      );
}
