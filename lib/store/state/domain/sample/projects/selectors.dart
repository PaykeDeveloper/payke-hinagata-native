// FIXME: SAMPLE CODE
import './notifier.dart';

final projectsSelector =
    projectsStateProvider.select((state) => state.entities);

final projectsStatusSelector =
    projectsStateProvider.select((state) => state.entitiesStatus);

final projectsErrorSelector =
    projectsStateProvider.select((state) => state.entitiesError);

final projectSelector = projectsStateProvider.select((state) => state.entity);

final projectStatusSelector =
    projectsStateProvider.select((state) => state.entityStatus);

final projectErrorSelector =
    projectsStateProvider.select((state) => state.entityError);
