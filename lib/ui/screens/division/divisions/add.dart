// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_input.dart';
import 'package:native_app/store/state/domain/division/divisions/models/divisions_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './widgets/form.dart';

class DivisionAddScreen extends ConsumerWidget {
  const DivisionAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<StoreResult?> onSubmit(DivisionInput input) async {
      final result = await ref
          .read(divisionsStateProvider.notifier)
          .addEntity(urlParams: const DivisionsUrl(), data: input);
      if (result is Success) {
        Navigator.of(context).pop();
      }
      return result;
    }

    final status = ref.watch(divisionsStatusSelector);
    final error = ref.watch(divisionsErrorSelector);
    return DivisionAdd(
      onSubmit: onSubmit,
      status: status,
      error: error,
    );
  }
}

typedef OnSubmit = Future<StoreResult?> Function(DivisionInput input);

class DivisionAdd extends StatefulWidget {
  const DivisionAdd({
    super.key,
    required OnSubmit onSubmit,
    required StateStatus status,
    required StoreError? error,
  })  : _onSubmit = onSubmit,
        _status = status,
        _error = error;
  final OnSubmit _onSubmit;
  final StateStatus _status;
  final StoreError? _error;

  @override
  State<DivisionAdd> createState() => _DivisionAddState();
}

class _DivisionAddState extends State<DivisionAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add division'),
      ),
      body: ErrorWrapper(
        error: widget._error,
        child: Loader(
          status: widget._status,
          child: DivisionForm(
            division: null,
            status: widget._status,
            onSubmit: widget._onSubmit,
          ),
        ),
      ),
    );
  }
}
