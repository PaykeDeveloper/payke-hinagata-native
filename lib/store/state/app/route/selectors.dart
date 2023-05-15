import './notifier.dart';

final tabSelector = routeStateProvider.select((state) => state.tab);

final isFirstTabSelector =
    routeStateProvider.select((state) => state.isFirstTab);

final homeParamsListSelector =
    routeStateProvider.select((state) => state.homeParamsList);

final projectParamsListSelector =
    routeStateProvider.select((state) => state.projectParamsList);

final memberParamsListSelector =
    routeStateProvider.select((state) => state.memberParamsList);
