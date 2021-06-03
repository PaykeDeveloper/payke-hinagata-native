// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_input.dart';
import 'package:native_app/store/state/domain/division/divisions/models/divisions_url.dart';
import 'package:native_app/store/state/domain/division/divisions/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './widgets/form.dart';

class DivisionAddScreen extends StatefulWidget {
  @override
  _DivisionAddScreenState createState() => _DivisionAddScreenState();
}

class _DivisionAddScreenState extends State<DivisionAddScreen> {
  Future<StoreResult?> _onSubmit(DivisionInput input) async {
    final result = await context
        .read<DivisionsNotifier>()
        .addEntity(urlParams: const DivisionsUrl(), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select(divisionsErrorSelector);
    final status = context.select(divisionsStatusSelector);
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
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
