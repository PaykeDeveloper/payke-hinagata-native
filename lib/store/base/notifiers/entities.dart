// ignore_for_file: invalid_use_of_internal_member
import 'package:native_app/store/base/models/backend_client.dart';
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
// ignore: implementation_imports,depend_on_referenced_packages
import 'package:riverpod/src/notifier.dart';

abstract class _EntitiesState<
        Entity,
        EntityUrl,
        EntityQuery extends JsonGenerator,
        EntitiesEntity,
        EntitiesUrl,
        EntitiesQuery extends JsonGenerator>
    extends NotifierBase<
        EntitiesState<Entity, EntityUrl, EntityQuery, EntitiesEntity,
            EntitiesUrl, EntitiesQuery>> {
  BackendClient getBackendClient();

  String getEntitiesUrl(EntitiesUrl url);

  String getEntityUrl(EntityUrl url);

  EntitiesEntity decodeEntities(Map<String, dynamic> json);

  Entity decodeEntity(Map<String, dynamic> json);
}

mixin EntitiesMixin<Entity, EntityUrl, EntityQuery extends JsonGenerator,
        EntitiesEntity, EntitiesUrl, EntitiesQuery extends JsonGenerator>
    implements
        _EntitiesState<Entity, EntityUrl, EntityQuery, EntitiesEntity,
            EntitiesUrl, EntitiesQuery> {
  Future resetEntities() async {
    state = state.copyWith(
      entities: [],
      entitiesStatus: StateStatus.initial,
      entitiesUrl: null,
      entitiesQuery: null,
      entitiesTimestamp: null,
      entitiesError: null,
    );
  }
}

mixin FetchEntitiesMixin<Entity, EntityUrl, EntityQuery extends JsonGenerator,
        EntitiesEntity, EntitiesUrl, EntitiesQuery extends JsonGenerator>
    on EntitiesMixin<Entity, EntityUrl, EntityQuery, EntitiesEntity,
        EntitiesUrl, EntitiesQuery> {
  final int _activeMinutes = 10;

  EntitiesState<Entity, EntityUrl, EntityQuery, EntitiesEntity, EntitiesUrl,
          EntitiesQuery>
      buildDefault() => EntitiesState<Entity, EntityUrl, EntityQuery,
          EntitiesEntity, EntitiesUrl, EntitiesQuery>();

  Future<StoreResult<List<EntitiesEntity>>> fetchEntities({
    required EntitiesUrl url,
    EntitiesQuery? query,
    bool silent = false,
  }) async {
    if (!silent) {
      state = state.copyWith(
        entitiesStatus: StateStatus.started,
        entitiesUrl: url,
        entitiesQuery: query,
      );
    }
    final result = await getBackendClient().getList(
      decode: decodeEntities,
      path: getEntitiesUrl(url),
      queryParameters: query?.toJson(),
    );
    result.when(
      success: (data) {
        state = state.copyWith(
          entities: data,
          entitiesStatus: StateStatus.done,
          entitiesTimestamp: DateTime.now(),
          entitiesError: null,
        );
      },
      failure: (error) {
        state = state.copyWith(
          entities: [],
          entitiesStatus: StateStatus.failed,
          entitiesTimestamp: DateTime.now(),
          entitiesError: error,
        );
      },
    );
    return result;
  }

  Future<StoreResult<Entity>> fetchEntity({
    required EntityUrl url,
    EntityQuery? query,
    bool silent = false,
  }) async {
    if (!silent) {
      state = state.copyWith(
        entityStatus: StateStatus.started,
        entityUrl: url,
        entityQuery: query,
      );
    }
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

  bool _shouldFetchEntities({
    required EntitiesUrl url,
    EntitiesQuery? query,
  }) {
    switch (state.entitiesStatus) {
      case StateStatus.initial:
      case StateStatus.failed:
        return true;
      case StateStatus.started:
        return false;
      case StateStatus.done:
        final preferState = _checkInActivePeriod(state.entitiesTimestamp) &&
            state.entitiesUrl == url &&
            state.entitiesQuery == query;
        return !preferState;
    }
  }

  Future fetchEntitiesIfNeeded({
    required EntitiesUrl url,
    EntitiesQuery? query,
    bool? reset,
  }) async {
    if (!_shouldFetchEntities(url: url, query: query)) {
      return null;
    }

    if (reset == true) {
      await resetEntitiesIfNeeded();
    }

    return fetchEntities(url: url, query: query);
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

  Future resetEntitiesIfNeeded() async {
    if (state.entitiesStatus != StateStatus.initial) {
      await resetEntities();
    }
  }

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

  Future resetAllIfNeeded() async {
    await resetEntitiesIfNeeded();
    await resetEntityIfNeeded();
  }
}

mixin CreateEntitiesMixin<
        Entity,
        EntityUrl,
        EntityQuery extends JsonGenerator,
        EntitiesEntity,
        EntitiesUrl,
        EntitiesQuery extends JsonGenerator,
        CreateInput extends JsonGenerator,
        CreateQuery extends JsonGenerator>
    on EntitiesMixin<Entity, EntityUrl, EntityQuery, EntitiesEntity,
        EntitiesUrl, EntitiesQuery> {
  Future<StoreResult<Entity>> addEntity({
    required EntitiesUrl urlParams,
    required CreateInput data,
    CreateQuery? query,
    bool useFormData = false,
  }) async {
    final result = await getBackendClient().postObject(
      decode: decodeEntity,
      path: getEntitiesUrl(urlParams),
      data: data,
      queryParameters: query?.toJson(),
      useFormData: useFormData,
    );
    switch (result) {
      case Success():
        if (state.entitiesStatus == StateStatus.done) {
          await resetEntities();
        }
      case Failure():
        break;
    }
    return result;
  }

  Future<StoreResult<Entity>> add({
    required EntitiesUrl urlParams,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await getBackendClient().post(
      decode: (data) => decodeEntity(data as Map<String, dynamic>),
      path: getEntitiesUrl(urlParams),
      data: data,
      queryParameters: queryParameters,
      useFormData: useFormData,
    );
    switch (result) {
      case Success():
        if (state.entitiesStatus == StateStatus.done) {
          await resetEntities();
        }
      case Failure():
        break;
    }
    return result;
  }
}

mixin UpdateEntitiesMixin<
        Entity,
        EntityUrl,
        EntityQuery extends JsonGenerator,
        EntitiesEntity,
        EntitiesUrl,
        EntitiesQuery extends JsonGenerator,
        UpdateInput extends JsonGenerator,
        UpdateQuery extends JsonGenerator>
    on EntitiesMixin<Entity, EntityUrl, EntityQuery, EntitiesEntity,
        EntitiesUrl, EntitiesQuery> {
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
    switch (result) {
      case Success(data: final data):
        if (state.entityStatus == StateStatus.done) {
          state = state.copyWith(
            entity: data,
            entityTimestamp: DateTime.now(),
          );
        }
        if (state.entitiesStatus == StateStatus.done) {
          await resetEntities();
        }
      case Failure():
        break;
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
    switch (result) {
      case Success(data: final data):
        if (state.entityStatus == StateStatus.done) {
          state = state.copyWith(
            entity: data,
            entityTimestamp: DateTime.now(),
          );
        }
        if (state.entitiesStatus == StateStatus.done) {
          await resetEntities();
        }
      case Failure():
        break;
    }
    return result;
  }
}

mixin DeleteEntitiesMixin<
        Entity,
        EntityUrl,
        EntityQuery extends JsonGenerator,
        EntitiesEntity,
        EntitiesUrl,
        EntitiesQuery extends JsonGenerator,
        DeleteQuery extends JsonGenerator>
    on EntitiesMixin<Entity, EntityUrl, EntityQuery, EntitiesEntity,
        EntitiesUrl, EntitiesQuery> {
  Future<StoreResult<void>> deleteEntity({
    required EntityUrl urlParams,
    DeleteQuery? query,
  }) async {
    final result = await getBackendClient().delete(
      decode: (json) {},
      path: getEntityUrl(urlParams),
      queryParameters: query?.toJson(),
    );
    switch (result) {
      case Success():
        if (state.entityStatus == StateStatus.done) {
          state = state.copyWith(
            entity: null,
            entityTimestamp: DateTime.now(),
          );
        }
        if (state.entitiesStatus == StateStatus.done) {
          await resetEntities();
        }
      case Failure():
        break;
    }
    return result;
  }
}
