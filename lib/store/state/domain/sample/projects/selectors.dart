// FIXME: SAMPLE CODE
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

import './models/project.dart';
import './notifier.dart';

ProviderListenable<List<Project>> projectsSelector(DivisionId divisionId) =>
    projectsStateProvider.call(divisionId).select((state) => state.entities);

ProviderListenable<StateStatus> projectsStatusSelector(DivisionId divisionId) =>
    projectsStateProvider
        .call(divisionId)
        .select((state) => state.entitiesStatus);

ProviderListenable<StoreError?> projectsErrorSelector(DivisionId divisionId) =>
    projectsStateProvider
        .call(divisionId)
        .select((state) => state.entitiesError);

ProviderListenable<Project?> projectSelector(DivisionId divisionId) =>
    projectsStateProvider.call(divisionId).select((state) => state.entity);

ProviderListenable<StateStatus> projectStatusSelector(DivisionId divisionId) =>
    projectsStateProvider
        .call(divisionId)
        .select((state) => state.entityStatus);

ProviderListenable<StoreError?> projectErrorSelector(DivisionId divisionId) =>
    projectsStateProvider.call(divisionId).select((state) => state.entityError);
