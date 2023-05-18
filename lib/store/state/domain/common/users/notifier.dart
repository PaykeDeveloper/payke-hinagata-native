import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/user.dart';
import './models/user_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class UsersState extends _$UsersState
    with
        EntitiesMixin<User, UserUrl, User, void>,
        FetchEntitiesMixin<User, UserUrl, User, void> {
  @override
  EntitiesState<User, UserUrl, User, void> build() => buildDefault();

  @override
  String getEntitiesUrl(void url) => '/api/v1/users';

  @override
  String getEntityUrl(UserUrl url) => '/api/v1/users/${url.id.value}';

  @override
  User decodeEntities(Map<String, dynamic> json) => User.fromJson(json);

  @override
  User decodeEntity(Map<String, dynamic> json) => User.fromJson(json);
}
