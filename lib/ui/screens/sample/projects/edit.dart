import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_input.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './widgets/form.dart';

class ProjectEditPage extends Page {
  ProjectEditPage({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug,
        super(
            key: ValueKey(
                "projectEditPage-${divisionId.value}-${projectSlug.value}"));
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

class ProjectEditScreen extends StatefulWidget {
  const ProjectEditScreen({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug;
  final DivisionId _divisionId;
  final ProjectSlug _projectSlug;

  @override
  _ProjectEditScreenState createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends ValidateFormState<ProjectEditScreen> {
  Future _initState() async {
    await context
        .read<ProjectsNotifier>()
        .fetchEntityIfNeeded(url: _getProjectUrl(), reset: true);
  }

  Future<StoreResult?> _onSubmit(ProjectInput input) async {
    final result = await context
        .read<ProjectsNotifier>()
        .mergeEntity(urlParams: _getProjectUrl(), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  Future _onPressedDelete() async {
    final result = await context
        .read<ProjectsNotifier>()
        .deleteEntity(urlParams: _getProjectUrl());
    if (result is Success) {
      await context.read<RouteStateNotifier>().replace(BottomTab.projects, []);
    }
  }

  ProjectUrl _getProjectUrl() => ProjectUrl(
        divisionId: widget._divisionId,
        slug: widget._projectSlug,
      );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final project = context.select(projectSelector);
    final error = context.select(projectErrorSelector);
    final status = context.select(projectStatusSelector);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete project',
            onPressed: project == null ? null : _onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: ProjectForm(
            project: project,
            status: status,
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
