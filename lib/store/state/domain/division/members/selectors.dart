// FIXME: SAMPLE CODE
import './notifier.dart';

final membersSelector = membersProvider.select((state) => state.entities);

final membersStatusSelector =
    membersProvider.select((state) => state.entitiesStatus);

final membersErrorSelector =
    membersProvider.select((state) => state.entitiesError);

final memberSelector = membersProvider.select((state) => state.entity);

final memberStatusSelector =
    membersProvider.select((state) => state.entityStatus);

final memberErrorSelector =
    membersProvider.select((state) => state.entityError);
