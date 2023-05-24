// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/common/users/models/user_id.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

import './member_id.dart';

part 'member.freezed.dart';

part 'member.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required MemberId id,
    required List<String> roleNames,
    required UserId userId,
    required DivisionId divisionId,
    required DateTime createdAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
