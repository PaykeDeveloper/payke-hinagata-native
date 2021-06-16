import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';

import './models/user.dart';
import './models/user_input.dart';
import './models/user_url.dart';
import './models/users_url.dart';

typedef UsersState
= EntitiesState<User, UserUrl, User, UsersUrl>;

class UsersNotifier extends EntitiesNotifier<User, UserUrl,
    User, UsersUrl, UserInput, UserInput> {
  UsersNotifier(UsersState state) : super(state);

  @override
  String getEntitiesUrl(UsersUrl url) => 'api/v1/users/';

  @override
  String getEntityUrl(UserUrl url) => 'api/v1/users/${url.id.value}/';

  @override
  User decodeEntities(Map<String, dynamic> json) => User.fromJson(json);

  @override
  User decodeEntity(Map<String, dynamic> json) => User.fromJson(json);
}
