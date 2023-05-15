import 'package:native_app/base/utils.dart';

import './models/user.dart';
import './notifier.dart';

final usersSelector = usersStateProvider.select((state) => state.entities);

final usersStatusSelector =
    usersStateProvider.select((state) => state.entitiesStatus);

final usersErrorSelector =
    usersStateProvider.select((state) => state.entitiesError);

final userSelector = usersStateProvider.select((state) => state.entity);

final userStatusSelector =
    usersStateProvider.select((state) => state.entityStatus);

final userErrorSelector =
    usersStateProvider.select((state) => state.entityError);

final usersMapSelector = usersStateProvider.select(
    (state) => convertListToMap(state.entities, (User user) => user.id.value));
