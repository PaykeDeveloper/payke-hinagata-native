import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/projects_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './add.dart';
import './detail.dart';
import './edit.dart';

class ProjectListPage extends Page {
  const ProjectListPage({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })   : _divisionId = divisionId,
        _openDrawer = openDrawer,
        super(key: const ValueKey("projectListPage"));
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => ProjectListScreen(
        divisionId: _divisionId,
        openDrawer: _openDrawer,
      ),
    );
  }
}

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })   : _divisionId = divisionId,
        _openDrawer = openDrawer;
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await context.read<ProjectsNotifier>().fetchEntitiesIfNeeded(
          url: ProjectsUrl(divisionId: widget._divisionId),
          reset: true,
        );
    setState(() {
      _loading = false;
    });
  }

  Future _onRefresh() async {
    await context
        .read<ProjectsNotifier>()
        .fetchEntities(url: ProjectsUrl(divisionId: widget._divisionId));
  }

  void _onPressedNew() {
    context.read<RouteStateNotifier>().push(
        BottomTab.projects, ProjectAddPage(divisionId: widget._divisionId));
  }

  void _onTapShow(ProjectId projectId) {
    context.read<RouteStateNotifier>().push(
          BottomTab.projects,
          ProjectDetailPage(
            divisionId: widget._divisionId,
            projectId: projectId,
          ),
        );
  }

  void _onPressedEdit(ProjectId projectId) {
    context.read<RouteStateNotifier>().push(
          BottomTab.projects,
          ProjectEditPage(
            divisionId: widget._divisionId,
            projectId: projectId,
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
  void didUpdateWidget(covariant ProjectListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (context.read<RouteState>().projectPages.isEmpty) {
      _initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.select(projectsSelector);
    final error = context.select(projectsErrorSelector);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ListItem(
                  project: project,
                  onTapItem: () => _onTapShow(project.id),
                  onPressedEdit: () => _onPressedEdit(project.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required Project project,
    required GestureTapCallback onTapItem,
    required VoidCallback onPressedEdit,
  })   : _project = project,
        _onTapItem = onTapItem,
        _onPressedEdit = onPressedEdit;

  final Project _project;
  final GestureTapCallback _onTapItem;
  final VoidCallback _onPressedEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: _onTapItem,
        leading: Text('${_project.id.value}'),
        title: Text(_project.name),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _onPressedEdit,
        ),
      ),
    );
  }
}
