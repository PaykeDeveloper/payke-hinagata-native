import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/ui/screens/division/members/detail.dart';

part 'detail.freezed.dart';

@freezed
class MemberDetailParams with _$MemberDetailParams implements RouteParams {
  const factory MemberDetailParams({
    required DivisionId divisionId,
    required MemberId memberId,
  }) = _MemberDetailParams;

  @override
  Page toPage() => MemberDetailPage(
        divisionId: divisionId,
        memberId: memberId,
      );
}
