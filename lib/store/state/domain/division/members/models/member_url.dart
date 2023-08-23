// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import 'member_id.dart';

part 'member_url.freezed.dart';

@freezed
class MemberUrl with _$MemberUrl {
  const factory MemberUrl({
    required MemberId id,
  }) = _MemberUrl;
}
