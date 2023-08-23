// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_input.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './widgets/form.dart';

class DivisionAddScreen extends HookConsumerWidget {
  const DivisionAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSubmit = useCallback((DivisionInput input) async {
      final result = await ref
          .read(divisionsStateProvider.notifier)
          .addEntity(urlParams: null, data: input);
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
      return result;
    }, []);

    final status = ref.watch(divisionsStatusSelector);
    final error = ref.watch(divisionsErrorSelector);
    return _DivisionAdd(
      onSubmit: onSubmit,
      status: status,
      error: error,
    );
  }
}

typedef _OnSubmit = Future<StoreResult?> Function(DivisionInput input);

class _DivisionAdd extends StatelessWidget {
  const _DivisionAdd({
    required this.onSubmit,
    required this.status,
    required this.error,
  });

  final _OnSubmit onSubmit;
  final StateStatus status;
  final StoreError? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add division'),
      ),
      body: ErrorWrapper(
        error: error,
        child: Loader(
          status: status,
          child: DivisionForm(
            division: null,
            status: status,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}
