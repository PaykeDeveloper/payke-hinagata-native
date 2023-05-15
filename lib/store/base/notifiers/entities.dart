import 'package:flutter/foundation.dart';
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

abstract class EntitiesNotifier<Entity, EntityUrl, EntitiesEntity, EntitiesUrl,
        CreateInput extends JsonGenerator, UpdateInput extends JsonGenerator>
    extends StateNotifier<
        EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl>>
    with LocatorMixin {
  EntitiesNotifier(
    EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl> state, {
    int activeMinutes = 10,
    bool reset = true,
  })  : _activeMinutes = activeMinutes,
        _reset = reset,
        super(state);

  final int _activeMinutes;
  final bool _reset;

  @override
  void update(Locator watch) {
    super.update(watch);
    final token = watch<BackendTokenState>().data;
    if (_reset && token == null) {
      resetAllIfNeeded();
    }
  }

  String getEntitiesUrl(EntitiesUrl url);

  String getEntityUrl(EntityUrl url);

  EntitiesEntity decodeEntities(Map<String, dynamic> json);

  Entity decodeEntity(Map<String, dynamic> json);

  Future<StoreResult<List<EntitiesEntity>>> fetchEntities({
    required EntitiesUrl url,
    Map<String, dynamic>? queryParameters,
  }) async {
    state = state.copyWith(
      entitiesStatus: StateStatus.started,
      entitiesUrl: url,
      entitiesQueryParameters: queryParameters,
    );
    final result = await read<BackendClient>().getList(
      decode: decodeEntities,
      path: getEntitiesUrl(url),
      queryParameters: queryParameters,
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
    Map<String, dynamic>? queryParameters,
  }) async {
    state = state.copyWith(
      entityStatus: StateStatus.started,
      entityUrl: url,
      entityQueryParameters: queryParameters,
    );
    final result = await read<BackendClient>().getObject(
      decode: decodeEntity,
      path: getEntityUrl(url),
      queryParameters: queryParameters,
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

  Future<StoreResult<Entity>> addEntity({
    required EntitiesUrl urlParams,
    required CreateInput data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().postObject(
      decode: decodeEntity,
      path: getEntitiesUrl(urlParams),
      data: data,
      queryParameters: queryParameters,
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entitiesStatus == StateStatus.done) {
        await resetEntities();
      }
    }
    return result;
  }

  Future<StoreResult<Entity>> add({
    required EntitiesUrl urlParams,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().post(
      decode: (data) => decodeEntity(data as Map<String, dynamic>),
      path: getEntitiesUrl(urlParams),
      data: data,
      queryParameters: queryParameters,
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entitiesStatus == StateStatus.done) {
        await resetEntities();
      }
    }
    return result;
  }

  Future<StoreResult<Entity>> mergeEntity({
    required EntityUrl urlParams,
    required UpdateInput data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().patchObject(
      decode: decodeEntity,
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
      if (state.entitiesStatus == StateStatus.done) {
        await resetEntities();
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
    final result = await read<BackendClient>().patch(
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
      if (state.entitiesStatus == StateStatus.done) {
        await resetEntities();
      }
    }
    return result;
  }

  Future<StoreResult<void>> deleteEntity({
    required EntityUrl urlParams,
    Map<String, dynamic>? queryParameters,
  }) async {
    final result = await read<BackendClient>().delete(
      decode: (json) {},
      path: getEntityUrl(urlParams),
      queryParameters: queryParameters,
    );
    if (result is Success) {
      if (state.entityStatus == StateStatus.done) {
        state = state.copyWith(
          entity: null,
          entityTimestamp: DateTime.now(),
        );
      }
      if (state.entitiesStatus == StateStatus.done) {
        await resetEntities();
      }
    }
    return result;
  }

  bool _checkInActivePeriod(DateTime? timestamp) {
    final now = DateTime.now();
    return timestamp != null &&
        now.difference(timestamp).inMinutes < _activeMinutes;
  }

  bool _shouldFetchEntities({
    required EntitiesUrl url,
    Map<String, dynamic>? queryParameters,
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
            mapEquals(state.entitiesQueryParameters, queryParameters);
        return !preferState;
    }
  }

  Future fetchEntitiesIfNeeded({
    required EntitiesUrl url,
    Map<String, dynamic>? queryParameters,
    bool? reset,
  }) async {
    if (!_shouldFetchEntities(url: url, queryParameters: queryParameters)) {
      return null;
    }

    if (reset == true) {
      await resetEntitiesIfNeeded();
    }

    return fetchEntities(url: url, queryParameters: queryParameters);
  }

  bool _shouldFetchEntity({
    required EntityUrl url,
    Map<String, dynamic>? queryParameters,
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
            mapEquals(state.entityQueryParameters, queryParameters);
        return !preferState;
    }
  }

  Future fetchEntityIfNeeded({
    required EntityUrl url,
    Map<String, dynamic>? queryParameters,
    bool? reset,
  }) async {
    if (!_shouldFetchEntity(url: url, queryParameters: queryParameters)) {
      return null;
    }

    if (reset == true) {
      await resetEntityIfNeeded();
    }

    return fetchEntity(url: url, queryParameters: queryParameters);
  }

  Future resetEntities() async {
    state = state.copyWith(
      entities: [],
      entitiesStatus: StateStatus.initial,
      entitiesUrl: null,
      entitiesQueryParameters: null,
      entitiesTimestamp: null,
      entitiesError: null,
    );
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
      entityQueryParameters: null,
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
