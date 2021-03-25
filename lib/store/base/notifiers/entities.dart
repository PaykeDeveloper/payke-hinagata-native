import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/state_result.dart';
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

  Future fetchEntities({
    required EntitiesEntity Function(Map<String, dynamic>) decode,
    required EntitiesUrl url,
  }) async {
    state = state.copyWith(
      entitiesStatus: StateStatus.started,
      entitiesUrl: url,
    );
    final result = await read<BackendClient>().getList(
      decode: decode,
      path: getEntitiesUrl(url),
    );
    if (result is Success<List<EntitiesEntity>>) {
      state = state.copyWith(
        entities: result.data,
        entitiesStatus: StateStatus.done,
        entitiesTimestamp: DateTime.now(),
        entitiesError: null,
      );
    } else if (result is Failure<List<EntitiesEntity>>) {
      state = state.copyWith(
        entities: [],
        entitiesStatus: StateStatus.failed,
        entitiesTimestamp: DateTime.now(),
        entitiesError: result.error,
      );
    }
    return result;
  }

  Future fetchEntity({
    required Entity Function(Map<String, dynamic>) decode,
    required EntityUrl url,
  }) async {
    state = state.copyWith(
      entityStatus: StateStatus.started,
      entityUrl: url,
    );
    final result = await read<BackendClient>().getObject(
      decode: decode,
      path: getEntityUrl(url),
    );
    if (result is Success<Entity>) {
      state = state.copyWith(
        entity: result.data,
        entityStatus: StateStatus.done,
        entityTimestamp: DateTime.now(),
        entityError: null,
      );
    } else if (result is Failure<Entity>) {
      state = state.copyWith(
        entity: null,
        entityStatus: StateStatus.failed,
        entityTimestamp: DateTime.now(),
        entityError: result.error,
      );
    }
    return result;
  }

  Future<StateResult<Entity>> addEntity({
    required Entity Function(Map<String, dynamic>) decode,
    required String Function(EntityUrl) urlBuild,
    required EntityUrl urlParams,
    CreateInput? data,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().postObject(
      decode: decode,
      path: urlBuild(urlParams),
      data: data,
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entitiesStatus == StateStatus.done ||
          state.entitiesStatus == StateStatus.failed) {
        resetEntities();
      }
    }
    return result;
  }

  Future<StateResult<Entity>> mergeEntity({
    required Entity Function(Map<String, dynamic>) decode,
    required String Function(EntityUrl) urlBuild,
    required EntityUrl urlParams,
    CreateInput? data,
    bool useFormData = false,
  }) async {
    final result = await read<BackendClient>().patchObject(
      decode: decode,
      path: urlBuild(urlParams),
      data: data,
      useFormData: useFormData,
    );
    if (result is Success<Entity>) {
      if (state.entityStatus == StateStatus.done ||
          state.entityStatus == StateStatus.failed) {
        state.copyWith(entity: result.data, entityTimestamp: DateTime.now());
      }
      if (state.entitiesStatus == StateStatus.done ||
          state.entitiesStatus == StateStatus.failed) {
        resetEntities();
      }
    }
    return result;
  }

  Future deleteEntity({
    required Entity Function(dynamic) decode,
    required String Function(EntityUrl) urlBuild,
    required EntityUrl urlParams,
  }) async {
    final result = await read<BackendClient>().delete(
      decode: decode,
      path: urlBuild(urlParams),
    );
    if (result is Success<Entity>) {
      if (state.entityStatus == StateStatus.done) {
        state.copyWith(entity: null, entityTimestamp: DateTime.now());
      }
      if (state.entitiesStatus == StateStatus.done ||
          state.entitiesStatus == StateStatus.failed) {
        resetEntities();
      }
    }
    return result;
  }

  bool checkInActivePeriod(DateTime? timestamp) {
    final now = DateTime.now();
    return timestamp != null &&
        now.difference(timestamp).inMinutes < _activeMinutes;
  }

  bool shouldFetchEntities({required EntitiesUrl url}) {
    switch (state.entitiesStatus) {
      case StateStatus.initial:
        return true;
      case StateStatus.started:
        return false;
      case StateStatus.done:
      case StateStatus.failed:
        final preferState = checkInActivePeriod(state.entitiesTimestamp) &&
            state.entitiesUrl == url;
        return !preferState;
    }
  }

  Future fetchEntitiesIfNeeded({
    required EntitiesEntity Function(Map<String, dynamic>) decode,
    required EntitiesUrl url,
  }) async {
    if (shouldFetchEntities(url: url)) {
      return null;
    }
    return fetchEntities(
      decode: decode,
      url: url,
    );
  }

  bool shouldFetchEntity({required EntityUrl url}) {
    switch (state.entityStatus) {
      case StateStatus.initial:
        return true;
      case StateStatus.started:
        return false;
      case StateStatus.done:
      case StateStatus.failed:
        final preferState = checkInActivePeriod(state.entityTimestamp) &&
            state.entityUrl == url;
        return !preferState;
    }
  }

  Future fetchEntityIfNeeded({
    required Entity Function(Map<String, dynamic>) decode,
    required EntityUrl url,
  }) async {
    if (shouldFetchEntity(url: url)) {
      return null;
    }
    return fetchEntity(
      decode: decode,
      url: url,
    );
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
