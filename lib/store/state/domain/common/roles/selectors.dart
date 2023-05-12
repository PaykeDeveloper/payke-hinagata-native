import './notifier.dart';

final rolesSelector = rolesStateProvider.select((state) => state.entities);

final memberRolesSelector = rolesStateProvider.select((state) =>
    state.entities.where((element) => element.type == 'member').toList());

final rolesStatusSelector =
    rolesStateProvider.select((state) => state.entitiesStatus);

final rolesErrorSelector =
    rolesStateProvider.select((state) => state.entitiesError);

final roleSelector = rolesStateProvider.select((state) => state.entity);

final roleStatusSelector =
    rolesStateProvider.select((state) => state.entityStatus);

final roleErrorSelector =
    rolesStateProvider.select((state) => state.entityError);
