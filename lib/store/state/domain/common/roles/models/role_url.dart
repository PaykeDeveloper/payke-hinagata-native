// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import './role_id.dart';

part 'role_url.freezed.dart';

@freezed
class RoleUrl with _$RoleUrl {
  const factory RoleUrl({
    required RoleId id,
  }) = _RoleUrl;
}
