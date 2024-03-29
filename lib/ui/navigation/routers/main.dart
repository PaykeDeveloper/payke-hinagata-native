import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/common/roles/notifier.dart';
import 'package:native_app/store/state/domain/common/users/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/screens/common/error.dart';
import 'package:native_app/ui/screens/common/loading.dart';
import 'package:native_app/ui/screens/division/divisions/list.dart';
import 'package:native_app/ui/screens/main.dart';

class MainRouter extends HookConsumerWidget {
  const MainRouter({super.key});

  void _initState(BuildContext context, WidgetRef ref) {
    ref.read(divisionsStateProvider.notifier).fetchEntitiesIfNeeded(url: null);
    ref.read(usersStateProvider.notifier).fetchEntitiesIfNeeded(url: null);
    ref.read(rolesStateProvider.notifier).fetchEntitiesIfNeeded(url: null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => _initState(context, ref));
      return null;
    }, []);

    final divisionId = ref.watch(divisionIdSelector);
    final hasDivisionId = ref.watch(divisionIdHasValueSelector);
    final divisions = ref.watch(divisionsSelector);
    final divisionsStatus = ref.watch(divisionsStatusSelector);
    final divisionsError = ref.watch(divisionsErrorSelector);

    if (!hasDivisionId || !divisionsStatus.isFinished) {
      return const LoadingScreen();
    }

    if (divisionsError != null) {
      return ErrorScreen(
        error: divisionsError,
        onPressedReload: () => ref
            .read(divisionsStateProvider.notifier)
            .fetchEntitiesIfNeeded(url: null),
      );
    }

    final division = divisionId != null
        ? divisions.firstOrNullWhere((element) => element.id == divisionId)
        : null;
    if (division == null) {
      return const DivisionListScreen();
    }

    return const MainScreen();
  }
}
