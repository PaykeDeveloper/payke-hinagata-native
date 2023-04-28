import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';

import './models/role.dart';
import './models/role_input.dart';
import './models/role_url.dart';
import './models/roles_url.dart';

typedef RolesState = EntitiesState<Role, RoleUrl, Role, RolesUrl>;

class RolesNotifier extends EntitiesNotifier<Role, RoleUrl, Role, RolesUrl,
    RoleInput, RoleInput> {
  RolesNotifier(super.ref, super.state);

  @override
  String getEntitiesUrl(RolesUrl url) => '/api/v1/roles';

  @override
  String getEntityUrl(RoleUrl url) => '/api/v1/roles/${url.id.value}';

  @override
  Role decodeEntities(Map<String, dynamic> json) => Role.fromJson(json);

  @override
  Role decodeEntity(Map<String, dynamic> json) => Role.fromJson(json);
}

final rolesProvider = StateNotifierProvider<RolesNotifier, RolesState>(
    (ref) => RolesNotifier(ref, const EntitiesState()));
