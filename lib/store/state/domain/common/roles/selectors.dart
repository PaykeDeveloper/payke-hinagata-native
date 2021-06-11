// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/role.dart';
import './notifier.dart';

List<Role> rolesSelector(RolesState state) => state.entities;

List<Role> memberRolesSelector(RolesState state) => state.entities.where((element) => element.type == 'member').toList();

StateStatus rolesStatusSelector(RolesState state) =>
    state.entitiesStatus;

StoreError? rolesErrorSelector(RolesState state) => state.entitiesError;

Role? roleSelector(RolesState state) => state.entity;

StateStatus roleStatusSelector(RolesState state) => state.entityStatus;

StoreError? roleErrorSelector(RolesState state) => state.entityError;
