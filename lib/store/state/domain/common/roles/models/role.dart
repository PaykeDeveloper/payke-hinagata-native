import 'package:freezed_annotation/freezed_annotation.dart';

import './role_id.dart';

part 'role.freezed.dart';
part 'role.g.dart';

@freezed
class Role with _$Role {
  const factory Role({
    required RoleId id,
    required String name,
    required bool required,
    required String type,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
