import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/ui/screens/sample/projects/detail.dart';

class ProjectDetailParams extends RouteParams {
  ProjectDetailParams({required this.divisionId, required this.projectSlug});

  final DivisionId divisionId;
  final ProjectSlug projectSlug;

  @override
  Page toPage() => ProjectDetailPage(
        divisionId: divisionId,
        projectSlug: projectSlug,
      );
}
