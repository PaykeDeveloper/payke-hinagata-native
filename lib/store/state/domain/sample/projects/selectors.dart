// FIXME: SAMPLE CODE
import './notifier.dart';

final projectsSelector = projectsProvider.select((state) => state.entities);

final projectsStatusSelector =
    projectsProvider.select((state) => state.entitiesStatus);

final projectsErrorSelector =
    projectsProvider.select((state) => state.entitiesError);

final projectSelector = projectsProvider.select((state) => state.entity);

final projectStatusSelector =
    projectsProvider.select((state) => state.entityStatus);

final projectErrorSelector =
    projectsProvider.select((state) => state.entityError);
