import './models/route_params.dart';
import './models/route_state.dart';

List<RouteParams> homeParamsListSelector(RouteState state) =>
    state.homeParamsList;

List<RouteParams> projectParamsListSelector(RouteState state) =>
    state.projectParamsList;

List<RouteParams> memberParamsListSelector(RouteState state) =>
    state.memberParamsList;
