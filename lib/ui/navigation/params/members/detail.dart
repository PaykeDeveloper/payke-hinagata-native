import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/ui/screens/division/members/detail.dart';

class MemberDetailParams implements RouteParams {
  MemberDetailParams({required this.divisionId, required this.memberId});

  final DivisionId divisionId;
  final MemberId memberId;

  @override
  Page toPage() => MemberDetailPage(
        divisionId: divisionId,
        memberId: memberId,
      );
}
