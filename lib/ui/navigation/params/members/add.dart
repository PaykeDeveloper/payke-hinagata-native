import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/ui/screens/division/members/add.dart';

class MemberAddParams implements RouteParams {
  MemberAddParams({required this.divisionId});

  final DivisionId divisionId;

  @override
  Page toPage() => MemberAddPage(
        divisionId: divisionId,
      );
}
