import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:state_notifier/state_notifier.dart';

class DivisionIdNotifier extends StateNotifier<StoreState<DivisionId?>> {
  DivisionIdNotifier() : super(const StoreState(null));

  Future setDivisionId(DivisionId divisionId) async {
    state = state.copyWith(data: divisionId);
  }
}
