import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/state_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:state_notifier/state_notifier.dart';

abstract class EntityNotifier<Entity, EntityUrl,
        CreateInput extends JsonGenerator, UpdateInput extends JsonGenerator>
    extends StateNotifier<EntityState<Entity, EntityUrl>> with LocatorMixin {
  EntityNotifier(EntityState<Entity, EntityUrl> state) : super(state);

  final _activeMinutes = 10;

  String _getEntityUrl(EntityUrl url);

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
      path: _getEntityUrl(url),
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
      if (state.entityStatus == StateStatus.done ||
          state.entityStatus == StateStatus.failed) {
        state.copyWith(entity: result.data, entityTimestamp: DateTime.now());
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
    }
    return result;
  }

  bool checkInActivePeriod(DateTime? timestamp) {
    final now = DateTime.now();
    return timestamp != null &&
        now.difference(timestamp).inMinutes < _activeMinutes;
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
