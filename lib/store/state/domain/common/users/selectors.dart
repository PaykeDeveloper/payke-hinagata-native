// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/user.dart';
import './notifier.dart';

List<User> usersSelector(UsersState state) => state.entities;

StateStatus usersStatusSelector(UsersState state) =>
    state.entitiesStatus;

StoreError? usersErrorSelector(UsersState state) => state.entitiesError;

User? userSelector(UsersState state) => state.entity;

StateStatus userStatusSelector(UsersState state) => state.entityStatus;

StoreError? userErrorSelector(UsersState state) => state.entityError;
