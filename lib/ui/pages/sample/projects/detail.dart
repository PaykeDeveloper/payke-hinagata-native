import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/pages/sample/projects/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './edit.dart';

class ProjectDetailPage extends Page {
  ProjectDetailPage({
    required DivisionId divisionId,
    required ProjectId projectId,
  })   : _divisionId = divisionId,
        _projectId = projectId,
        super(
            key: ValueKey(
                "projectDetailPage-${divisionId.value}-${projectId.value}"));
  final DivisionId _divisionId;
  final ProjectId _projectId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => ProjectDetailScreen(
        divisionId: _divisionId,
        projectId: _projectId,
      ),
    );
  }
}

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({
    required DivisionId divisionId,
    required ProjectId projectId,
  })   : _divisionId = divisionId,
        _projectId = projectId;
  final DivisionId _divisionId;
  final ProjectId _projectId;

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Future _initState() async {
    await context.read<ProjectsNotifier>().fetchEntityIfNeeded(
        url: ProjectUrl(divisionId: widget._divisionId, id: widget._projectId),
        reset: true);
  }

  void _onPressedEdit() {
    context.read<RouteStateNotifier>().push(
          BottomTab.projects,
          ProjectEditPage(
            divisionId: widget._divisionId,
            projectId: widget._projectId,
          ),
        );
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
    final project = context.select(projectSelector);
    final error = context.select(projectErrorSelector);
    final status = context.select(projectStatusSelector);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit project',
            onPressed: project == null ? null : _onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: Center(
            child: Text('Name: ${project?.name}'),
          ),
        ),
      ),
    );
  }
}
