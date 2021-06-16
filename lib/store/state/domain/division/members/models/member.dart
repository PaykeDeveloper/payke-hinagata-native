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
    @JsonKey(name: 'role_names') required List<String> roleNames,
    @JsonKey(name: 'user_id') required UserId userId,
    @JsonKey(name: 'division_id') required DivisionId divisionId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) =>
      _$MemberFromJson(json);
}
