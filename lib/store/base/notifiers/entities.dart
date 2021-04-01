import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:state_notifier/state_notifier.dart';

abstract class EntitiesNotifier<Entity, EntityUrl, EntitiesEntity, EntitiesUrl,
        CreateInput extends JsonGenerator, UpdateInput extends JsonGenerator>
    extends StateNotifier<
        EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl>>
    with LocatorMixin {
  EntitiesNotifier(
      EntitiesState<Entity, EntityUrl, EntitiesEntity, EntitiesUrl> state)
      : super(state);

  final _activeMinutes = 10;

  String getEntitiesUrl(EntitiesUrl url);

  String getEntityUrl(EntityUrl url);

  EntitiesEntity decodeEntities(Map<String, dynamic> json);

  Entity decodeEntity(Map<String, dynamic> json);

  Future fetchEntities({
    required EntitiesUrl url,
  }) async {
    state = state.copyWith(
      entitiesStatus: StateStatus.started,
      entitiesUrl: url,
    );
    final result = await read<BackendClient>().getList(
      decode: decodeEntities,
      path: getEntitiesUrl(url),
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

  Future fetchEntity({required EntityUrl url}) async {
    state = state.copyWith(
      entityStatus: StateStatus.started,
      entityUrl: url,
    );
    final result = await read<BackendClient>().getObject(
      decode: decodeEntity,
      path: getEntityUrl(url),
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
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().postObject(
      decode: decodeEntity,
      path: getEntitiesUrl(urlParams),
      data: data,
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
    required CreateInput data,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().patchObject(
      decode: decodeEntity,
      path: getEntityUrl(urlParams),
      data: data,
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
  }) async {
    final result = await read<BackendClient>().delete(
      decode: (json) {},
      path: getEntityUrl(urlParams),
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

  bool _shouldFetchEntities({required EntitiesUrl url}) {
    switch (state.entitiesStatus) {
      case StateStatus.initial:
      case StateStatus.failed:
        return true;
      case StateStatus.started:
        return false;
      case StateStatus.done:
        final preferState = _checkInActivePeriod(state.entitiesTimestamp) &&
            state.entitiesUrl == url;
        return !preferState;
    }
  }

  Future fetchEntitiesIfNeeded({
    required EntitiesUrl url,
    bool? reset,
  }) async {
    if (!_shouldFetchEntities(url: url)) {
      return null;
    }

    if (reset == true) {
      await resetEntitiesIfNeeded();
    }

    return fetchEntities(url: url);
  }

  bool _shouldFetchEntity({required EntityUrl url}) {
    switch (state.entityStatus) {
      case StateStatus.initial:
      case StateStatus.failed:
        return true;
      case StateStatus.started:
        return false;
      case StateStatus.done:
        final preferState = _checkInActivePeriod(state.entityTimestamp) &&
            state.entityUrl == url;
        return !preferState;
    }
  }

  Future fetchEntityIfNeeded({
    required EntityUrl url,
    bool? reset,
  }) async {
    if (!_shouldFetchEntity(url: url)) {
      return null;
    }

    if (reset == true) {
      await resetEntityIfNeeded();
    }

    return fetchEntity(url: url);
  }

  Future resetEntities() async {
    state = state.copyWith(
      entities: [],
      entitiesStatus: StateStatus.initial,
      entitiesUrl: null,
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
