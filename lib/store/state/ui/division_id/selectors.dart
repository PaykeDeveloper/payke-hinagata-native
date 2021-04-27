import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

DivisionId? divisionIdSelector(StoreState<DivisionId?> state) => state.data;

StateStatus divisionIdStateSelector(StoreState<DivisionId?> state) =>
    state.status;
