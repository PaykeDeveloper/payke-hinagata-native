import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/backend_client.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';

abstract class _EntityState<Entity, EntityUrl,
        EntityQuery extends JsonGenerator>
    extends Notifier<EntityState<Entity, EntityUrl, EntityQuery>> {
  BackendClient getBackendClient();

  String getEntityUrl(EntityUrl url);

  Entity decodeEntity(Map<String, dynamic> json);
}

mixin EntityMixIn<Entity, EntityUrl, EntityQuery extends JsonGenerator>
    implements _EntityState<Entity, EntityUrl, EntityQuery> {}

mixin FetchEntityMixin<Entity, EntityUrl, EntityQuery extends JsonGenerator>
    on EntityMixIn<Entity, EntityUrl, EntityQuery> {
  final int _activeMinutes = 10;

  EntityState<Entity, EntityUrl, EntityQuery> buildDefault() =>
      EntityState<Entity, EntityUrl, EntityQuery>();

  Future resetEntity() async {
    state = state.copyWith(
      entity: null,
      entityStatus: StateStatus.initial,
      entityUrl: null,
      entityQuery: null,
      entityTimestamp: null,
      entityError: null,
    );
  }

  Future resetEntityIfNeeded() async {
    if (state.entityStatus != StateStatus.initial) {
      await resetEntity();
    }
  }

  Future<StoreResult<Entity>> fetchEntity({
    required EntityUrl url,
    EntityQuery? query,
  }) async {
    state = state.copyWith(
      entityStatus: StateStatus.started,
      entityUrl: url,
      entityQuery: query,
    );
    final result = await getBackendClient().getObject(
      decode: decodeEntity,
      path: getEntityUrl(url),
      queryParameters: query?.toJson(),
    );
    result.when(
      success: (data) {
        state = state.copyWith(
          entity: data,
          entityStatus: StateStatus.done,
          entityTimestamp: DateTime.now(),
          entityError: null,
        );
      },
      failure: (error) {
        state = state.copyWith(
          entity: null,
          entityStatus: StateStatus.failed,
          entityTimestamp: DateTime.now(),
          entityError: error,
        );
      },
    );
    return result;
  }

  bool _checkInActivePeriod(DateTime? timestamp) {
    final now = DateTime.now();
    return timestamp != null &&
        now.difference(timestamp).inMinutes < _activeMinutes;
  }

  bool _shouldFetchEntity({
    required EntityUrl url,
    EntityQuery? query,
  }) {
    switch (state.entityStatus) {
      case StateStatus.initial:
      case StateStatus.failed:
        return true;
      case StateStatus.started:
        return false;
      case StateStatus.done:
        final preferState = _checkInActivePeriod(state.entityTimestamp) &&
            state.entityUrl == url &&
            state.entityQuery == query;
        return !preferState;
    }
  }

  Future fetchEntityIfNeeded({
    required EntityUrl url,
    EntityQuery? query,
    bool? reset,
  }) async {
    if (!_shouldFetchEntity(url: url, query: query)) {
      return null;
    }

    if (reset == true) {
      await resetEntityIfNeeded();
    }

    return fetchEntity(url: url, query: query);
  }
}

mixin CreateEntityMixin<Entity, EntityUrl, EntityQuery extends JsonGenerator,
        CreateInput extends JsonGenerator, CreateQuery extends JsonGenerator>
    on EntityMixIn<Entity, EntityUrl, EntityQuery> {
  Future<StoreResult<Entity>> addEntity({
    required EntityUrl urlParams,
    required CreateInput data,
    CreateQuery? query,
    bool useFormData = false,
  }) async {
    final result = await getBackendClient().postObject(
      decode: decodeEntity,
      path: getEntityUrl(urlParams),
      data: data,
      queryParameters: query?.toJson(),
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entityStatus == StateStatus.done) {
        state = state.copyWith(
          entity: result.data,
          entityTimestamp: DateTime.now(),
        );
      }
    }
    return result;
  }

  Future<StoreResult<Entity>> add({
    required EntityUrl urlParams,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await getBackendClient().post(
      decode: (data) => decodeEntity(data as Map<String, dynamic>),
      path: getEntityUrl(urlParams),
      data: data,
      queryParameters: queryParameters,
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entityStatus == StateStatus.done) {
        state = state.copyWith(
          entity: result.data,
          entityTimestamp: DateTime.now(),
        );
      }
    }
    return result;
  }
}

mixin UpdateEntityMixin<Entity, EntityUrl, EntityQuery extends JsonGenerator,
        UpdateInput extends JsonGenerator, UpdateQuery extends JsonGenerator>
    on EntityMixIn<Entity, EntityUrl, EntityQuery> {
  Future<StoreResult<Entity>> mergeEntity({
    required EntityUrl urlParams,
    required UpdateInput data,
    UpdateQuery? query,
    bool useFormData = false,
  }) async {
    final result = await getBackendClient().patchObject(
      decode: decodeEntity,
      path: getEntityUrl(urlParams),
      data: data,
      queryParameters: query?.toJson(),
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entityStatus == StateStatus.done) {
        state = state.copyWith(
          entity: result.data,
          entityTimestamp: DateTime.now(),
        );
      }
    }
    return result;
  }

  Future<StoreResult<Entity>> merge({
    required EntityUrl urlParams,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await getBackendClient().patch(
      decode: (data) => decodeEntity(data as Map<String, dynamic>),
      path: getEntityUrl(urlParams),
      data: data,
      queryParameters: queryParameters,
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entityStatus == StateStatus.done) {
        state = state.copyWith(
          entity: result.data,
          entityTimestamp: DateTime.now(),
        );
      }
    }
    return result;
  }
}

mixin DeleteEntityMixin<Entity, EntityUrl, EntityQuery extends JsonGenerator,
        DeleteQuery extends JsonGenerator>
    on EntityMixIn<Entity, EntityUrl, EntityQuery> {
  Future<StoreResult<void>> deleteEntity({
    required EntityUrl urlParams,
    DeleteQuery? query,
  }) async {
    final result = await getBackendClient().delete(
      decode: (json) {},
      path: getEntityUrl(urlParams),
      queryParameters: query?.toJson(),
    );
    if (result is Success) {
      if (state.entityStatus == StateStatus.done) {
        state = state.copyWith(
          entity: null,
          entityTimestamp: DateTime.now(),
        );
      }
    }
    return result;
  }
}
