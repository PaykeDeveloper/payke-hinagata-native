import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/ui/screens/division/members/edit.dart';

part 'edit.freezed.dart';

@freezed
class MemberEditParams with _$MemberEditParams implements RouteParams {
  const factory MemberEditParams({
    required DivisionId divisionId,
    required MemberId memberId,
  }) = _MemberEditParams;

  @override
  Page toPage() => MemberEditPage(
        divisionId: divisionId,
        memberId: memberId,
      );
}
