// FIXME: SAMPLE CODE

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

import './widgets/form.dart';

class DivisionEditScreen extends StatelessWidget {
  const DivisionEditScreen({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Widget build(BuildContext context) {
    void initState() {
      context
          .read<DivisionsNotifier>()
          .fetchEntityIfNeeded(url: DivisionUrl(id: _divisionId), reset: true);
    }

    final navigator = Navigator.of(context);

    Future<StoreResult?> onSubmit(DivisionInput input) async {
      final result = await context
          .read<DivisionsNotifier>()
          .mergeEntity(urlParams: DivisionUrl(id: _divisionId), data: input);
      if (result is Success) {
        navigator.pop();
      }
      return result;
    }

    Future onPressedDelete() async {
      final result = await context
          .read<DivisionsNotifier>()
          .deleteEntity(urlParams: DivisionUrl(id: _divisionId));
      if (result is Success) {
        navigator.pop();
      }
    }

    final status = context.select(divisionStatusSelector);
    final error = context.select(divisionErrorSelector);
    final division = context.select(divisionSelector);
    final selectedId = context.select(divisionIdSelector);

    return DivisionEdit(
      initState: initState,
      onSubmit: onSubmit,
      onPressedDelete: onPressedDelete,
      status: status,
      error: error,
      division: division,
      selectedId: selectedId,
    );
  }
}

typedef OnSubmit = Future<StoreResult?> Function(DivisionInput input);

class DivisionEdit extends StatefulWidget {
  const DivisionEdit({
    required VoidCallback initState,
    required OnSubmit onSubmit,
    required Function0<Future> onPressedDelete,
    required StateStatus status,
    required StoreError? error,
    required Division? division,
    required DivisionId? selectedId,
  })  : _initState = initState,
        _onSubmit = onSubmit,
        _onPressedDelete = onPressedDelete,
        _status = status,
        _error = error,
        _division = division,
        _selectedId = selectedId;
  final VoidCallback _initState;
  final OnSubmit _onSubmit;
  final Function0<Future> _onPressedDelete;
  final StateStatus _status;
  final StoreError? _error;
  final Division? _division;
  final DivisionId? _selectedId;

  @override
  State<DivisionEdit> createState() => _DivisionEditState();
}

class _DivisionEditState extends State<DivisionEdit> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget._initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit division'),
        actions: [
          if (widget._division?.id != widget._selectedId)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete division',
              onPressed:
                  widget._division != null ? widget._onPressedDelete : null,
            ),
        ],
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: widget._initState,
        child: Loader(
          status: widget._status,
          child: DivisionForm(
            division: widget._division,
            status: widget._status,
            onSubmit: widget._onSubmit,
          ),
        ),
      ),
    );
  }
}
