// FIXME: SAMPLE CODE
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';

import './models/member.dart';
import './notifier.dart';

ProviderListenable<List<Member>> membersSelector(DivisionId divisionId) =>
    membersStateProvider.call(divisionId).select((state) => state.entities);

ProviderListenable<StateStatus> membersStatusSelector(DivisionId divisionId) =>
    membersStateProvider
        .call(divisionId)
        .select((state) => state.entitiesStatus);

ProviderListenable<StoreError?> membersErrorSelector(DivisionId divisionId) =>
    membersStateProvider
        .call(divisionId)
        .select((state) => state.entitiesError);

ProviderListenable<Member?> memberSelector(DivisionId divisionId) =>
    membersStateProvider.call(divisionId).select((state) => state.entity);

ProviderListenable<StateStatus> memberStatusSelector(DivisionId divisionId) =>
    membersStateProvider.call(divisionId).select((state) => state.entityStatus);

ProviderListenable<StoreError?> memberErrorSelector(DivisionId divisionId) =>
    membersStateProvider.call(divisionId).select((state) => state.entityError);
