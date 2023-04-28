// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './widgets/form.dart';

class ProjectEditPage extends Page {
  const ProjectEditPage({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug;
  final DivisionId _divisionId;
  final ProjectSlug _projectSlug;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => ProjectEditScreen(
        divisionId: _divisionId,
        projectSlug: _projectSlug,
      ),
    );
  }
}

class ProjectEditScreen extends ConsumerWidget {
  const ProjectEditScreen({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug;
  final DivisionId _divisionId;
  final ProjectSlug _projectSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectUrl = ProjectUrl(divisionId: _divisionId, slug: _projectSlug);
    Future<StoreResult?> onSubmit(Map<String, dynamic> input) async {
      final result = await ref
          .read(projectsProvider.notifier)
          .merge(urlParams: projectUrl, data: input, useFormData: true);
      if (result is Success) {
        Navigator.of(context).pop();
      }
      return result;
    }

    void initState() {
      ref
          .read(projectsProvider.notifier)
          .fetchEntityIfNeeded(url: projectUrl, reset: true);
    }

    Future onPressedDelete() async {
      final result = await ref
          .read(projectsProvider.notifier)
          .deleteEntity(urlParams: projectUrl);
      if (result is Success) {
        await ref
            .read(routeStateProvider.notifier)
            .replace(BottomTab.projects, []);
      }
    }

    final status = ref.watch(projectStatusSelector);
    final error = ref.watch(projectErrorSelector);
    final project = ref.watch(projectSelector);

    return ProjectEdit(
      onSubmit: onSubmit,
      initState: initState,
      onPressedDelete: onPressedDelete,
      status: status,
      error: error,
      project: project,
    );
  }
}

typedef OnSubmit = Future<StoreResult?> Function(Map<String, dynamic> data);

class ProjectEdit extends StatefulWidget {
  const ProjectEdit({
    required OnSubmit onSubmit,
    required VoidCallback initState,
    required VoidCallback onPressedDelete,
    required StateStatus status,
    required StoreError? error,
    required Project? project,
  })  : _onSubmit = onSubmit,
        _initState = initState,
        _onPressedDelete = onPressedDelete,
        _status = status,
        _error = error,
        _project = project;
  final OnSubmit _onSubmit;
  final VoidCallback _initState;
  final VoidCallback _onPressedDelete;
  final StateStatus _status;
  final StoreError? _error;
  final Project? _project;

  @override
  State<ProjectEdit> createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {
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
        title: const Text('Edit project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete project',
            onPressed: widget._project == null ? null : widget._onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: widget._initState,
        child: Loader(
          status: widget._status,
          child: ProjectForm(
            project: widget._project,
            status: widget._status,
            onSubmit: widget._onSubmit,
          ),
        ),
      ),
    );
  }
}
