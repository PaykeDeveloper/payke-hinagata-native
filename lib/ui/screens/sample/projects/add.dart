// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './widgets/form.dart';

class ProjectAddPage extends Page {
  const ProjectAddPage({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => ProjectAddScreen(divisionId: _divisionId),
    );
  }
}

class ProjectAddScreen extends HookConsumerWidget {
  const ProjectAddScreen({super.key, required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSubmit = useCallback<_OnSubmit>((data) async {
      final result = await ref
          .read(projectsStateProvider(_divisionId).notifier)
          .add(urlParams: null, data: data, useFormData: true);
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
      return result;
    }, [_divisionId]);

    final status = ref.watch(projectsStatusSelector(_divisionId));
    final error = ref.watch(projectsErrorSelector(_divisionId));
    return _ProjectAdd(onSubmit: onSubmit, status: status, error: error);
  }
}

typedef _OnSubmit = Future<StoreResult?> Function(Map<String, dynamic> data);

class _ProjectAdd extends StatelessWidget {
  const _ProjectAdd({
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
        title: const Text('Add project'),
      ),
      body: ErrorWrapper(
        error: error,
        child: Loader(
          status: status,
          child: ProjectForm(
            project: null,
            status: status,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}
