import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './state_error.dart';

part 'entities_state.freezed.dart';

@freezed
class EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl>
    with _$EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl> {
  const factory EntitiesState({
    @Default(null) Entity? entity,
    @Default(StateStatus.initial) StateStatus entityStatus,
    @Default(null) EntityUrl? entityUrl,
    @Default(null) DateTime? entityTimestamp,
    @Default(null) StateError? entityError,
    @Default([]) List<EntitiesEntity> entities,
    @Default(StateStatus.initial) StateStatus entitiesStatus,
    @Default(null) EntitiesUrl? entitiesUrl,
    @Default(null) DateTime? entitiesTimestamp,
    @Default(null) StateError? entitiesError,
  }) = _EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl>;
}
