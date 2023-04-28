import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/common/roles/models/roles_url.dart';
import 'package:native_app/store/state/domain/common/roles/notifier.dart';
import 'package:native_app/store/state/domain/common/users/models/users_url.dart';
import 'package:native_app/store/state/domain/common/users/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/divisions_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/screens/common/loading.dart';
import 'package:native_app/ui/screens/division/divisions/list.dart';
import 'package:native_app/ui/screens/main.dart';

class MainRouter extends HookConsumerWidget {
  void _initState(BuildContext context, WidgetRef ref) {
    ref
        .read(divisionsProvider.notifier)
        .fetchEntitiesIfNeeded(url: const DivisionsUrl());
    ref
        .read(usersProvider.notifier)
        .fetchEntitiesIfNeeded(url: const UsersUrl());
    ref
        .read(rolesProvider.notifier)
        .fetchEntitiesIfNeeded(url: const RolesUrl());
    ref.read(divisionIdProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(Duration.zero, () {
        _initState(context, ref);
      });
      return null;
    }, []);

    final divisionId = ref.watch(divisionIdSelector);
    final divisionIdStatus = ref.watch(divisionIdStateSelector);
    final divisions = ref.watch(divisionsSelector);
    final divisionsStatus = ref.watch(divisionsStatusSelector);

    if (divisionIdStatus != StateStatus.done ||
        divisionsStatus != StateStatus.done) {
      return LoadingScreen();
    }

    final division = divisionId != null
        ? divisions.firstWhereOrNull((element) => element.id == divisionId)
        : null;
    if (division == null) {
      return DivisionListScreen();
    }

    return MainScreen();
  }
}
