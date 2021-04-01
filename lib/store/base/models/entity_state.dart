import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './store_error.dart';

part 'entity_state.freezed.dart';

@freezed
class EntityState<Entity, EntityUrl> with _$EntityState<Entity, EntityUrl> {
  const factory EntityState({
    @Default(null) Entity? entity,
    @Default(StateStatus.initial) StateStatus entityStatus,
    @Default(null) EntityUrl? entityUrl,
    @Default(null) DateTime? entityTimestamp,
    @Default(null) StoreError? entityError,
  }) = _EntityState<Entity, EntityUrl>;
}
