import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/user.dart';
import './models/user_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class UsersState extends _$UsersState
    with
        EntitiesMixin<User, UserUrl, JsonGenerator, User, void, JsonGenerator>,
        FetchEntitiesMixin<User, UserUrl, JsonGenerator, User, void,
            JsonGenerator> {
  @override
  EntitiesState<User, UserUrl, JsonGenerator, User, void, JsonGenerator>
      build() => buildDefault();

  @override
  BackendClient getBackendClient() => ref.read(backendClientProvider);

  @override
  String getEntitiesUrl(void url) => '/api/v1/users';

  @override
  String getEntityUrl(UserUrl url) => '/api/v1/users/${url.id.value}';

  @override
  User decodeEntities(Map<String, dynamic> json) => User.fromJson(json);

  @override
  User decodeEntity(Map<String, dynamic> json) => User.fromJson(json);
}
