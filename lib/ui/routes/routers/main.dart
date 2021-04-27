import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/divisions_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/pages/common/loading.dart';
import 'package:native_app/ui/pages/division/divisions/list.dart';
import 'package:native_app/ui/pages/main.dart';
import 'package:provider/provider.dart';

class MainRouter extends HookWidget {
  void _initState(BuildContext context) {
    context
        .read<DivisionsNotifier>()
        .fetchEntitiesIfNeeded(url: const DivisionsUrl());
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(Duration.zero, () {
        _initState(context);
      });
    }, []);

    final divisionId = context.select(divisionIdSelector);
    final divisionIdStatus = context.select(divisionIdStateSelector);
    final divisions = context.select(divisionsSelector);
    final divisionsStatus = context.select(divisionsStatusSelector);

    if (divisionIdStatus != StateStatus.done ||
        divisionsStatus != StateStatus.done) {
      return LoadingScreen();
    }

    final division = divisionId != null
        ? divisions.firstWhereOrNull((element) => element.id == divisionId)
        : null;
    if (division == null) {
      return const DivisionListScreen();
    }

    return MainScreen();
  }
}
