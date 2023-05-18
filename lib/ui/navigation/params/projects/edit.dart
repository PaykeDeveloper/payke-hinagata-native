import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/ui/screens/sample/projects/edit.dart';

part 'edit.freezed.dart';

@freezed
class ProjectEditParams with _$ProjectEditParams implements RouteParams {
  const factory ProjectEditParams({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  }) = _ProjectEditParams;

  @override
  Page toPage() => ProjectEditPage(
        divisionId: divisionId,
        projectSlug: projectSlug,
      );
}
