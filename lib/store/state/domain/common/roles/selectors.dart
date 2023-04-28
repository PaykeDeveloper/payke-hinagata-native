import './notifier.dart';

final rolesSelector = rolesProvider.select((state) => state.entities);

final memberRolesSelector = rolesProvider.select((state) =>
    state.entities.where((element) => element.type == 'member').toList());

final rolesStatusSelector =
    rolesProvider.select((state) => state.entitiesStatus);

final rolesErrorSelector = rolesProvider.select((state) => state.entitiesError);

final roleSelector = rolesProvider.select((state) => state.entity);

final roleStatusSelector = rolesProvider.select((state) => state.entityStatus);

final roleErrorSelector = rolesProvider.select((state) => state.entityError);
