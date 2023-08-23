// FIXME: SAMPLE CODE
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/navigation/params/projects/add.dart';
import 'package:native_app/ui/navigation/params/projects/detail.dart';
import 'package:native_app/ui/navigation/params/projects/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

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

class ProjectListScreen extends HookConsumerWidget {
  const ProjectListScreen({
    super.key,
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer;
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = useCallback(() async {
      await ref
          .read(projectsStateProvider(_divisionId).notifier)
          .fetchEntitiesIfNeeded(url: null, reset: true);
    }, [_divisionId]);

    useEffect(() {
      Future.delayed(Duration.zero, initState);
      return null;
    }, [initState]);

    final onRefresh = useCallback(() async {
      await ref
          .read(projectsStateProvider(_divisionId).notifier)
          .fetchEntities(url: null, silent: true);
    }, [_divisionId]);

    final onPressedNew = useCallback(() {
      ref
          .read(routeStateProvider.notifier)
          .push(BottomTab.projects, ProjectAddParams(divisionId: _divisionId));
    }, [_divisionId]);

    final onPressedEdit = useCallback((ProjectSlug projectSlug) {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.projects,
            ProjectEditParams(
              divisionId: _divisionId,
              projectSlug: projectSlug,
            ),
          );
    }, [_divisionId]);

    final onTapShow = useCallback((ProjectSlug projectSlug) {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.projects,
            ProjectDetailParams(
              divisionId: _divisionId,
              projectSlug: projectSlug,
            ),
          );
    }, [_divisionId]);

    final error = ref.watch(projectsErrorSelector(_divisionId));
    final projects = ref.watch(projectsSelector(_divisionId));

    return _ProjectList(
      openDrawer: _openDrawer,
      onPressedReload: initState,
      onRefresh: onRefresh,
      onPressedNew: onPressedNew,
      onPressedEdit: onPressedEdit,
      onTapShow: onTapShow,
      error: error,
      projects: projects,
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({
    required this.openDrawer,
    required this.onPressedReload,
    required this.onRefresh,
    required this.onPressedNew,
    required this.onPressedEdit,
    required this.onTapShow,
    required this.error,
    required this.projects,
  });

  final VoidCallback openDrawer;
  final Function0<Future> onPressedReload;
  final Function0<Future> onRefresh;
  final VoidCallback onPressedNew;
  final Function1<ProjectSlug, void> onPressedEdit;
  final Function1<ProjectSlug, void> onTapShow;
  final StoreError? error;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
        child: Loader(
          loading: false,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ListItem(
                  project: project,
                  onTapItem: () => onTapShow(project.slug),
                  onPressedEdit: () => onPressedEdit(project.slug),
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
