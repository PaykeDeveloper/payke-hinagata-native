import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';

abstract class _EntityState<Entity, EntityUrl>
    extends Notifier<EntityState<Entity, EntityUrl>> {
  String getEntityUrl(EntityUrl url);

  Entity decodeEntity(Map<String, dynamic> json);
}

mixin EntityMixin<Entity, EntityUrl, CreateInput extends JsonGenerator,
        UpdateInput extends JsonGenerator>
    implements _EntityState<Entity, EntityUrl> {
  final int _activeMinutes = 10;
  final bool _reset = true;

  EntityState<Entity, EntityUrl> buildDefault() {
    if (_reset) {
      ref.listen<StoreState<BackendToken?>>(backendTokenStateProvider,
          (previous, next) {
        if (next.data == null) {
          resetEntityIfNeeded();
        }
      });
    }
    return EntityState<Entity, EntityUrl>();
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
    final result = await ref.read(backendClientProvider).getObject(
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
    final result = await ref.read(backendClientProvider).postObject(
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

  Future<StoreResult<Entity>> add({
    required EntityUrl urlParams,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await ref.read(backendClientProvider).post(
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

  Future<StoreResult<Entity>> mergeEntity({
    required EntityUrl urlParams,
    required UpdateInput data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  }) async {
    final result = await ref.read(backendClientProvider).patchObject(
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
    }
    return result;
  }

  Future<StoreResult<void>> deleteEntity({
    required EntityUrl urlParams,
    Map<String, dynamic>? queryParameters,
  }) async {
    final result = await ref.read(backendClientProvider).delete(
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
