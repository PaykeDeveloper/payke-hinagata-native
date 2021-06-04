import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

import './notifier.dart';

DivisionId? divisionIdSelector(DivisionIdState state) => state.data;

StateStatus divisionIdStateSelector(DivisionIdState state) => state.status;
