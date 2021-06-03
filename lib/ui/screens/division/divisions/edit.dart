// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_input.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './widgets/form.dart';

class DivisionEditScreen extends StatefulWidget {
  const DivisionEditScreen({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  _DivisionEditScreenState createState() => _DivisionEditScreenState();
}

class _DivisionEditScreenState extends ValidateFormState<DivisionEditScreen> {
  Future _initState() async {
    await context.read<DivisionsNotifier>().fetchEntityIfNeeded(
        url: DivisionUrl(id: widget._divisionId), reset: true);
  }

  Future<StoreResult?> _onSubmit(DivisionInput input) async {
    final result = await context.read<DivisionsNotifier>().mergeEntity(
        urlParams: DivisionUrl(id: widget._divisionId), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  Future _onPressedDelete() async {
    final result = await context
        .read<DivisionsNotifier>()
        .deleteEntity(urlParams: DivisionUrl(id: widget._divisionId));
    if (result is Success) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final division = context.select(divisionSelector);
    final error = context.select(divisionErrorSelector);
    final status = context.select(divisionStatusSelector);
    final selectedId = context.select(divisionIdSelector);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit division'),
        actions: [
          if (division?.id != selectedId)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete division',
              onPressed: division != null ? _onPressedDelete : null,
            ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: DivisionForm(
            division: division,
            status: status,
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
