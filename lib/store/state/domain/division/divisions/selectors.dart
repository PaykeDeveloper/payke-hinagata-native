// FIXME: SAMPLE CODE
import './notifier.dart';

final divisionsSelector = divisionsProvider.select((state) => state.entities);

final divisionsStatusSelector =
    divisionsProvider.select((state) => state.entitiesStatus);

final divisionsErrorSelector =
    divisionsProvider.select((state) => state.entitiesError);

final divisionSelector = divisionsProvider.select((state) => state.entity);

final divisionStatusSelector =
    divisionsProvider.select((state) => state.entityStatus);

final divisionErrorSelector =
    divisionsProvider.select((state) => state.entityError);
