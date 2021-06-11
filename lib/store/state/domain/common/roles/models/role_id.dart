import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_id.freezed.dart';

part 'role_id.g.dart';

@freezed
class RoleId with _$RoleId {
  const factory RoleId(int value) = _RoleId;

  factory RoleId.fromJson(dynamic value) => RoleId(value as int);
}
