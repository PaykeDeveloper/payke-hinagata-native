// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

part 'members_url.freezed.dart';

@freezed
class MembersUrl with _$MembersUrl {
  const factory MembersUrl({
    required DivisionId divisionId,
  }) = _MembersUrl;
}
