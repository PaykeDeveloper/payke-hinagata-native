// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/division.dart';
import './models/division_input.dart';
import './models/division_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class DivisionsState extends _$DivisionsState
    with
        EntitiesMixin<Division, DivisionUrl, JsonGenerator, Division, void,
            JsonGenerator>,
        FetchEntitiesMixin<Division, DivisionUrl, JsonGenerator, Division, void,
            JsonGenerator>,
        CreateEntitiesMixin<Division, DivisionUrl, JsonGenerator, Division,
            void, JsonGenerator, DivisionInput, JsonGenerator>,
        UpdateEntitiesMixin<Division, DivisionUrl, JsonGenerator, Division,
            void, JsonGenerator, DivisionInput, JsonGenerator>,
        DeleteEntitiesMixin<Division, DivisionUrl, JsonGenerator, Division,
            void, JsonGenerator, JsonGenerator> {
  @override
  EntitiesState<Division, DivisionUrl, JsonGenerator, Division, void,
      JsonGenerator> build() => buildDefault();

  @override
  BackendClient getBackendClient() => ref.read(backendClientProvider);

  @override
  String getEntitiesUrl(void url) => '/api/v1/divisions';

  @override
  String getEntityUrl(DivisionUrl url) => '/api/v1/divisions/${url.id.value}';

  @override
  Division decodeEntities(Map<String, dynamic> json) => Division.fromJson(json);

  @override
  Division decodeEntity(Map<String, dynamic> json) => Division.fromJson(json);

  @override
  Division? convertToEntitiesEntity(Division entity) => entity;

  @override
  bool isTargetEntitiesEntity(DivisionUrl urlParams, Division entity) =>
      urlParams.id == entity.id;
}
