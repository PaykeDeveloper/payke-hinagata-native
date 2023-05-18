import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/ui/screens/sample/projects/add.dart';

part 'add.freezed.dart';

@freezed
class ProjectAddParams with _$ProjectAddParams implements RouteParams {
  const factory ProjectAddParams({
    required DivisionId divisionId,
  }) = _ProjectAddParams;

  @override
  Page toPage() => ProjectAddPage(
        divisionId: divisionId,
      );
}
