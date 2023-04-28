// FIXME: SAMPLE CODE
import './notifier.dart';

final divisionIdSelector = divisionIdProvider.select((state) => state.data);

final divisionIdStateSelector =
    divisionIdProvider.select((state) => state.status);
