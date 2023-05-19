// FIXME: SAMPLE CODE
import './notifier.dart';

final divisionIdSelector =
    divisionIdStateProvider.select((state) => state.value);

final divisionIdHasValueSelector =
    divisionIdStateProvider.select((state) => state.hasValue);
