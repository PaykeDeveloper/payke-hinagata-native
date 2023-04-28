import 'package:native_app/base/utils.dart';

import './models/user.dart';
import './notifier.dart';

final usersSelector = usersProvider.select((state) => state.entities);

final usersStatusSelector =
    usersProvider.select((state) => state.entitiesStatus);

final usersErrorSelector = usersProvider.select((state) => state.entitiesError);

final userSelector = usersProvider.select((state) => state.entity);

final userStatusSelector = usersProvider.select((state) => state.entityStatus);

final userErrorSelector = usersProvider.select((state) => state.entityError);

final usersMapSelector = usersProvider.select(
    (state) => convertListToMap(state.entities, (User user) => user.id.value));
