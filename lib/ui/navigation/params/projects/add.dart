import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/ui/screens/sample/projects/add.dart';

class ProjectAddParams implements RouteParams {
  ProjectAddParams({required this.divisionId});

  final DivisionId divisionId;

  @override
  Page toPage() => ProjectAddPage(
        divisionId: divisionId,
      );
}
