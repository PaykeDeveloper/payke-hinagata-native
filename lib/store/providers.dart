import 'dart:ui';

import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/single_child_widget.dart';

import './base/models/entities_state.dart';
import './state/app/backend_client/models/backend_client.dart';
import './state/app/backend_client/notifier.dart';
import './state/app/backend_token/notifier.dart';
import './state/app/locale/notifier.dart';
import './state/app/login/notifier.dart';
import './state/app/logout/notifier.dart';
import './state/app/route/models/route_state.dart';
import './state/app/route/notifier.dart';
import './state/domain/common/roles/notifier.dart';
import './state/domain/common/users/notifier.dart';
import './state/domain/division/divisions/notifier.dart';
import './state/domain/division/members/notifier.dart';
import './state/domain/sample/projects/notifier.dart';
import './state/ui/division_id/notifier.dart';

List<SingleChildWidget> getProviders() {
  return [
    StateNotifierProvider<LocaleNotifier, Locale?>(
        create: (context) => LocaleNotifier()),
    StateNotifierProvider<BackendTokenNotifier, BackendTokenState>(
        create: (context) => BackendTokenNotifier()),
    StateNotifierProvider<BackendClientNotifier, BackendClient>(
        create: (context) => BackendClientNotifier()),
    StateNotifierProvider<LoginNotifier, LoginState>(
        create: (context) => LoginNotifier()),
    StateNotifierProvider<LogoutNotifier, LogoutState>(
        create: (context) => LogoutNotifier()),
    StateNotifierProvider<RouteStateNotifier, RouteState>(
        create: (context) => RouteStateNotifier()),
    StateNotifierProvider<RolesNotifier, RolesState>(
        create: (context) => RolesNotifier(const EntitiesState())),

    // FIXME: SAMPLE CODE
    StateNotifierProvider<DivisionIdNotifier, DivisionIdState>(
        create: (context) => DivisionIdNotifier()),
    StateNotifierProvider<DivisionsNotifier, DivisionsState>(
        create: (context) => DivisionsNotifier(const EntitiesState())),
    StateNotifierProvider<UsersNotifier, UsersState>(
        create: (context) => UsersNotifier(const EntitiesState())),
    StateNotifierProvider<MembersNotifier, MembersState>(
        create: (context) => MembersNotifier(const EntitiesState())),
    StateNotifierProvider<ProjectsNotifier, ProjectsState>(
        create: (context) => ProjectsNotifier(const EntitiesState())),
  ];
}
