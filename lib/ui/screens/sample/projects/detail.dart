// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/navigation/params/projects/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class ProjectDetailPage extends Page {
  ProjectDetailPage({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug,
        super(
            key: ValueKey(
                "projectDetailPage-${divisionId.value}-${projectSlug.value}"));
  final DivisionId _divisionId;
  final ProjectSlug _projectSlug;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => ProjectDetailScreen(
        divisionId: _divisionId,
        projectSlug: _projectSlug,
      ),
    );
  }
}

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug;
  final DivisionId _divisionId;
  final ProjectSlug _projectSlug;

  @override
  Widget build(BuildContext context) {
    void initState() {
      context.read<ProjectsNotifier>().fetchEntityIfNeeded(
          url: ProjectUrl(divisionId: _divisionId, slug: _projectSlug),
          reset: true);
    }

    void onPressedEdit() {
      context.read<RouteStateNotifier>().push(
            BottomTab.projects,
            ProjectEditParams(
              divisionId: _divisionId,
              projectSlug: _projectSlug,
            ),
          );
    }

    final status = context.select(projectStatusSelector);
    final error = context.select(projectErrorSelector);
    final project = context.select(projectSelector);
    return ProjectDetail(
      initState: initState,
      onPressedEdit: onPressedEdit,
      status: status,
      error: error,
      project: project,
    );
  }
}

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({
    required VoidCallback initState,
    required VoidCallback onPressedEdit,
    required StateStatus status,
    required StoreError? error,
    required Project? project,
  })  : _initState = initState,
        _onPressedEdit = onPressedEdit,
        _status = status,
        _error = error,
        _project = project;
  final VoidCallback _initState;
  final VoidCallback _onPressedEdit;
  final StateStatus _status;
  final StoreError? _error;
  final Project? _project;

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
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
        title: const Text('Project detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit project',
            onPressed: widget._project == null ? null : widget._onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: widget._initState,
        child: Loader(
          status: widget._status,
          child: Center(
            child: Text('Name: ${widget._project?.name}'),
          ),
        ),
      ),
    );
  }
}
