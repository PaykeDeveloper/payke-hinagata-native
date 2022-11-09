import 'package:flutter/foundation.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

abstract class EntityNotifier<Entity, EntityUrl,
        CreateInput extends JsonGenerator, UpdateInput extends JsonGenerator>
    extends StateNotifier<EntityState<Entity, EntityUrl>> with LocatorMixin {
  EntityNotifier(
    EntityState<Entity, EntityUrl> state, {
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
      resetEntityIfNeeded();
    }
  }

  String getEntityUrl(EntityUrl url);

  Entity decodeEntity(Map<String, dynamic> json);

  Future fetchEntity({
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
    required EntityUrl urlParams,
    required CreateInput data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().postObject(
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
    }
    return result;
  }

  Future<StoreResult<Entity>> mergeEntity({
    required EntityUrl urlParams,
    required CreateInput data,
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
    }
    return result;
  }

  bool _checkInActivePeriod(DateTime? timestamp) {
    final now = DateTime.now();
    return timestamp != null &&
        now.difference(timestamp).inMinutes < _activeMinutes;
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
}
