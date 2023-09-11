// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
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

class ProjectDetailPage extends Page {
  const ProjectDetailPage({
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
      builder: (context) => ProjectDetailScreen(
        divisionId: _divisionId,
        projectSlug: _projectSlug,
      ),
    );
  }
}

class ProjectDetailScreen extends HookConsumerWidget {
  const ProjectDetailScreen({
    super.key,
    required DivisionId divisionId,
    required ProjectSlug projectSlug,
  })  : _divisionId = divisionId,
        _projectSlug = projectSlug;
  final DivisionId _divisionId;
  final ProjectSlug _projectSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = useCallback(() {
      ref.read(projectsStateProvider(_divisionId).notifier).fetchEntityIfNeeded(
          url: ProjectUrl(slug: _projectSlug), reset: true);
    }, [_divisionId, _projectSlug]);

    useEffect(() {
      Future.microtask(initState);
      return null;
    }, [initState]);

    final onPressedEdit = useCallback(() {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.projects,
            ProjectEditParams(
              divisionId: _divisionId,
              projectSlug: _projectSlug,
            ),
          );
    }, [_divisionId, _projectSlug]);

    final status = ref.watch(projectStatusSelector(_divisionId));
    final error = ref.watch(projectErrorSelector(_divisionId));
    final project = ref.watch(projectSelector(_divisionId));
    return _ProjectDetail(
      onPressedReload: initState,
      onPressedEdit: onPressedEdit,
      status: status,
      error: error,
      project: project,
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({
    required this.onPressedReload,
    required this.onPressedEdit,
    required this.status,
    required this.error,
    required this.project,
  });

  final VoidCallback onPressedReload;
  final VoidCallback onPressedEdit;
  final StateStatus status;
  final StoreError? error;
  final Project? project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit project',
            onPressed: project == null ? null : onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
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
