// FIXME: SAMPLE CODE
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_input.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './widgets/form.dart';

class DivisionEditScreen extends HookConsumerWidget {
  const DivisionEditScreen({super.key, required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = useCallback(() {
      ref
          .read(divisionsStateProvider.notifier)
          .fetchEntityIfNeeded(url: DivisionUrl(id: _divisionId), reset: true);
    }, [_divisionId]);

    useEffect(() {
      Future.delayed(Duration.zero, initState);
      return null;
    }, [initState]);

    final onSubmit = useCallback((DivisionInput input) async {
      final result = await ref
          .read(divisionsStateProvider.notifier)
          .mergeEntity(urlParams: DivisionUrl(id: _divisionId), data: input);
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
      return result;
    }, [_divisionId]);

    final onPressedDelete = useCallback(() async {
      final result = await ref
          .read(divisionsStateProvider.notifier)
          .deleteEntity(urlParams: DivisionUrl(id: _divisionId));
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
    }, [_divisionId]);

    final status = ref.watch(divisionStatusSelector);
    final error = ref.watch(divisionErrorSelector);
    final division = ref.watch(divisionSelector);
    final selectedId = ref.watch(divisionIdSelector);

    return _DivisionEdit(
      onPressedReload: initState,
      onSubmit: onSubmit,
      onPressedDelete: onPressedDelete,
      status: status,
      error: error,
      division: division,
      selectedId: selectedId,
    );
  }
}

typedef _OnSubmit = Future<StoreResult?> Function(DivisionInput input);

class _DivisionEdit extends StatelessWidget {
  const _DivisionEdit({
    required this.onPressedReload,
    required this.onSubmit,
    required this.onPressedDelete,
    required this.status,
    required this.error,
    required this.division,
    required this.selectedId,
  });

  final VoidCallback onPressedReload;
  final _OnSubmit onSubmit;
  final Function0<Future> onPressedDelete;
  final StateStatus status;
  final StoreError? error;
  final Division? division;
  final DivisionId? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit division'),
        actions: [
          if (division?.id != selectedId)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete division',
              onPressed: division != null ? onPressedDelete : null,
            ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
        child: Loader(
          status: status,
          child: DivisionForm(
            division: division,
            status: status,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}
