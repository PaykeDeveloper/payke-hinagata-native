// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/projects_url.dart';
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

class ProjectAddScreen extends ConsumerWidget {
  const ProjectAddScreen({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlParams = ProjectsUrl(divisionId: _divisionId);
    Future<StoreResult<Project>> onSubmit(Map<String, dynamic> data) async {
      final result = await ref
          .read(projectsStateProvider.notifier)
          .add(urlParams: urlParams, data: data, useFormData: true);
      if (result is Success) {
        Navigator.of(context).pop();
      }
      return result;
    }

    final status = ref.watch(projectsStatusSelector);
    final error = ref.watch(projectsErrorSelector);
    return ProjectAdd(onSubmit: onSubmit, status: status, error: error);
  }
}

typedef OnSubmit = Future<StoreResult?> Function(Map<String, dynamic> data);

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({
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
  State<ProjectAdd> createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add project'),
      ),
      body: ErrorWrapper(
        error: widget._error,
        child: Loader(
          status: widget._status,
          child: ProjectForm(
            project: null,
            status: widget._status,
            onSubmit: widget._onSubmit,
          ),
        ),
      ),
    );
  }
}
