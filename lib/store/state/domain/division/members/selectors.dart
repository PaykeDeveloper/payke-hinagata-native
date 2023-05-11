// FIXME: SAMPLE CODE
import './notifier.dart';

final membersSelector = membersStateProvider.select((state) => state.entities);

final membersStatusSelector =
    membersStateProvider.select((state) => state.entitiesStatus);

final membersErrorSelector =
    membersStateProvider.select((state) => state.entitiesError);

final memberSelector = membersStateProvider.select((state) => state.entity);

final memberStatusSelector =
    membersStateProvider.select((state) => state.entityStatus);

final memberErrorSelector =
    membersStateProvider.select((state) => state.entityError);
