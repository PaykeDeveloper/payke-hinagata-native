// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

import 'member_id.dart';

part 'member_url.freezed.dart';

@freezed
class MemberUrl with _$MemberUrl {
  const factory MemberUrl({
    required DivisionId divisionId,
    required MemberId id,
  }) = _MemberUrl;
}
