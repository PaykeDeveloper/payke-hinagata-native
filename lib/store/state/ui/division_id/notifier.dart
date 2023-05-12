// FIXME: SAMPLE CODE
import 'package:native_app/base/preferences.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@riverpod
class DivisionIdState extends _$DivisionIdState {
  @override
  StoreState<DivisionId?> build() => const StoreState(null);

  Future initialize() async {
    state = state.copyWith(status: StateStatus.started);

    final value = await Preferences.divisionId.get();
    final divisionId = value != null ? DivisionId(value) : null;
    state = state.copyWith(data: divisionId, status: StateStatus.done);
  }

  Future<bool> setDivisionId(DivisionId divisionId) async {
    final result = await Preferences.divisionId.set(divisionId.value);
    state = state.copyWith(data: divisionId);
    return result;
  }
}
