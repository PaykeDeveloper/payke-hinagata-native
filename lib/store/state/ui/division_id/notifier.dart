// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/preference.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class DivisionIdState extends _$DivisionIdState {
  @override
  StoreState<DivisionId?> build() => const StoreState(null);

  Future initialize() async {
    state = state.copyWith(status: StateStatus.started);

    final value = await divisionId.get();
    final data = value != null ? DivisionId(value) : null;
    state = state.copyWith(data: data, status: StateStatus.done);
  }

  Future<bool> setDivisionId(DivisionId data) async {
    final result = await divisionId.set(data.value);
    state = state.copyWith(data: data);
    return result;
  }

  Future<bool?> reset() async {
    final result = await divisionId.remove();
    state = build();
    return result;
  }
}
