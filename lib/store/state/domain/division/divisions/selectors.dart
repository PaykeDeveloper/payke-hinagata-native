import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/division.dart';
import './models/division_url.dart';
import './models/divisions_url.dart';

List<Division> divisionsSelector(
        EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> state) =>
    state.entities;

StateStatus divisionsStatusSelector(
        EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> state) =>
    state.entitiesStatus;

StoreError? divisionsErrorSelector(
        EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> state) =>
    state.entitiesError;

Division? divisionSelector(
        EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> state) =>
    state.entity;

StateStatus divisionStatusSelector(
        EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> state) =>
    state.entityStatus;

StoreError? divisionErrorSelector(
        EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> state) =>
    state.entityError;
