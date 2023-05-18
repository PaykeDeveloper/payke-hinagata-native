import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/app/route/models/route_params.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/ui/screens/division/members/add.dart';

part 'add.freezed.dart';

@freezed
class MemberAddParams with _$MemberAddParams implements RouteParams {
  const factory MemberAddParams({
    required DivisionId divisionId,
  }) = _MemberAddParams;

  @override
  Page toPage() => MemberAddPage(
        divisionId: divisionId,
      );
}
