// FIXME: SAMPLE CODE
import './notifier.dart';

final divisionsSelector =
    divisionsStateProvider.select((state) => state.entities);

final divisionsStatusSelector =
    divisionsStateProvider.select((state) => state.entitiesStatus);

final divisionsErrorSelector =
    divisionsStateProvider.select((state) => state.entitiesError);

final divisionSelector = divisionsStateProvider.select((state) => state.entity);

final divisionStatusSelector =
    divisionsStateProvider.select((state) => state.entityStatus);

final divisionErrorSelector =
    divisionsStateProvider.select((state) => state.entityError);
