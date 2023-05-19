import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/common/roles/notifier.dart';
import 'package:native_app/store/state/domain/common/users/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class LogoutState extends _$LogoutState {
  @override
  Null build() => null;

  Future logout() async {
    final client = ref.read(backendClientProvider);
    await client.post(
      decode: (json) => null,
      path: '/api/v1/logout',
    );

    ref.read(backendTokenStateProvider.notifier).remove();
    ref.read(divisionIdStateProvider.notifier).remove();
    ref.read(routeStateProvider.notifier).resetAll();
    ref.read(rolesStateProvider.notifier).resetAllIfNeeded();
    ref.read(usersStateProvider.notifier).resetAllIfNeeded();
    ref.read(divisionsStateProvider.notifier).resetAllIfNeeded();
    ref.read(membersStateProvider.notifier).resetAllIfNeeded();
    ref.read(projectsStateProvider.notifier).resetAllIfNeeded();
  }
}
