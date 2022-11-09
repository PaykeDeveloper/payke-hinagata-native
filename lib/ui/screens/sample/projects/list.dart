// FIXME: SAMPLE CODE
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/app/route/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/domain/sample/projects/models/projects_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/navigation/params/projects/add.dart';
import 'package:native_app/ui/navigation/params/projects/detail.dart';
import 'package:native_app/ui/navigation/params/projects/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class ProjectListPage extends Page {
  const ProjectListPage({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer;
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

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer;
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  Widget build(BuildContext context) {
    Future initState() async {
      await context.read<ProjectsNotifier>().fetchEntitiesIfNeeded(
            url: ProjectsUrl(divisionId: _divisionId),
            reset: true,
          );
    }

    Future onRefresh() async {
      await context
          .read<ProjectsNotifier>()
          .fetchEntities(url: ProjectsUrl(divisionId: _divisionId));
    }

    void onPressedNew() {
      context
          .read<RouteStateNotifier>()
          .push(BottomTab.projects, ProjectAddParams(divisionId: _divisionId));
    }

    void onTapShow(ProjectSlug projectSlug) {
      context.read<RouteStateNotifier>().push(
            BottomTab.projects,
            ProjectDetailParams(
              divisionId: _divisionId,
              projectSlug: projectSlug,
            ),
          );
    }

    void onPressedEdit(ProjectSlug projectSlug) {
      context.read<RouteStateNotifier>().push(
            BottomTab.projects,
            ProjectEditParams(
              divisionId: _divisionId,
              projectSlug: projectSlug,
            ),
          );
    }

    bool checkRouteEmpty() =>
        projectParamsListSelector(context.read<RouteState>()).isEmpty;

    final error = context.select(projectsErrorSelector);
    final projects = context.select(projectsSelector);

    return ProjectList(
      openDrawer: _openDrawer,
      initState: initState,
      onRefresh: onRefresh,
      onPressedNew: onPressedNew,
      onTapShow: onTapShow,
      onPressedEdit: onPressedEdit,
      checkRouteEmpty: checkRouteEmpty,
      error: error,
      projects: projects,
    );
  }
}

class ProjectList extends StatefulWidget {
  const ProjectList({
    required VoidCallback openDrawer,
    required Function0<Future> initState,
    required Function0<Future> onRefresh,
    required VoidCallback onPressedNew,
    required Function1<ProjectSlug, void> onTapShow,
    required Function1<ProjectSlug, void> onPressedEdit,
    required Function0<bool> checkRouteEmpty,
    required StoreError? error,
    required List<Project> projects,
  })  : _openDrawer = openDrawer,
        _initState = initState,
        _onRefresh = onRefresh,
        _onPressedNew = onPressedNew,
        _onTapShow = onTapShow,
        _onPressedEdit = onPressedEdit,
        _checkRouteEmpty = checkRouteEmpty,
        _error = error,
        _projects = projects;
  final VoidCallback _openDrawer;
  final Function0<Future> _initState;
  final Function0<Future> _onRefresh;
  final VoidCallback _onPressedNew;
  final Function1<ProjectSlug, void> _onTapShow;
  final Function1<ProjectSlug, void> _onPressedEdit;
  final Function0<bool> _checkRouteEmpty;
  final StoreError? _error;
  final List<Project> _projects;

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await widget._initState();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  void didUpdateWidget(covariant ProjectList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._checkRouteEmpty()) {
      _initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget._onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading,
          child: RefreshIndicator(
            onRefresh: widget._onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget._projects.length,
              itemBuilder: (context, index) {
                final project = widget._projects[index];
                return _ListItem(
                  project: project,
                  onTapItem: () => widget._onTapShow(project.slug),
                  onPressedEdit: () => widget._onPressedEdit(project.slug),
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
  })  : _project = project,
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
