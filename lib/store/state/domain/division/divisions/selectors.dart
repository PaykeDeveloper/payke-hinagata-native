// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/division.dart';
import './notifier.dart';

List<Division> divisionsSelector(DivisionsState state) => state.entities;

StateStatus divisionsStatusSelector(DivisionsState state) =>
    state.entitiesStatus;

StoreError? divisionsErrorSelector(DivisionsState state) => state.entitiesError;

Division? divisionSelector(DivisionsState state) => state.entity;

StateStatus divisionStatusSelector(DivisionsState state) => state.entityStatus;

StoreError? divisionErrorSelector(DivisionsState state) => state.entityError;
