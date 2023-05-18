import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/role.dart';
import './models/role_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class RolesState extends _$RolesState
    with
        EntitiesMixin<Role, RoleUrl, JsonGenerator, Role, void, JsonGenerator>,
        FetchEntitiesMixin<Role, RoleUrl, JsonGenerator, Role, void,
            JsonGenerator> {
  @override
  EntitiesState<Role, RoleUrl, JsonGenerator, Role, void, JsonGenerator>
      build() => buildDefault();

  @override
  BackendClient getBackendClient() => ref.read(backendClientProvider);

  @override
  String getEntitiesUrl(void url) => '/api/v1/roles';

  @override
  String getEntityUrl(RoleUrl url) => '/api/v1/roles/${url.id.value}';

  @override
  Role decodeEntities(Map<String, dynamic> json) => Role.fromJson(json);

  @override
  Role decodeEntity(Map<String, dynamic> json) => Role.fromJson(json);
}
