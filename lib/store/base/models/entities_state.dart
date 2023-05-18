import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './store_error.dart';

part 'entities_state.freezed.dart';

@freezed
class EntitiesState<Entity, EntityUrl, EntityQuery extends JsonGenerator,
        EntitiesEntity, EntitiesUrl, EntitiesQuery extends JsonGenerator>
    with
        _$EntitiesState<Entity, EntityUrl, EntityQuery, EntitiesEntity,
            EntitiesUrl, EntitiesQuery> {
  const factory EntitiesState({
    @Default(null) Entity? entity,
    @Default(StateStatus.initial) StateStatus entityStatus,
    @Default(null) EntityUrl? entityUrl,
    @Default(null) EntityQuery? entityQuery,
    @Default(null) DateTime? entityTimestamp,
    @Default(null) StoreError? entityError,
    @Default([]) List<EntitiesEntity> entities,
    @Default(StateStatus.initial) StateStatus entitiesStatus,
    @Default(null) EntitiesUrl? entitiesUrl,
    @Default(null) EntitiesQuery? entitiesQuery,
    @Default(null) DateTime? entitiesTimestamp,
    @Default(null) StoreError? entitiesError,
  }) = _EntitiesState<Entity, EntityUrl, EntityQuery, EntitiesEntity,
      EntitiesUrl, EntitiesQuery>;
}
