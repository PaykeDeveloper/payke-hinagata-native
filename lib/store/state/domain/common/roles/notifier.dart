import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/role.dart';
import './models/role_input.dart';
import './models/role_url.dart';
import './models/roles_url.dart';

part 'notifier.g.dart';

@riverpod
class RolesState extends _$RolesState
    with EntitiesMixin<Role, RoleUrl, Role, RolesUrl, RoleInput, RoleInput> {
  @override
  EntitiesState<Role, RoleUrl, Role, RolesUrl> build() => buildDefault();

  @override
  String getEntitiesUrl(RolesUrl url) => '/api/v1/roles';

  @override
  String getEntityUrl(RoleUrl url) => '/api/v1/roles/${url.id.value}';

  @override
  Role decodeEntities(Map<String, dynamic> json) => Role.fromJson(json);

  @override
  Role decodeEntity(Map<String, dynamic> json) => Role.fromJson(json);
}
