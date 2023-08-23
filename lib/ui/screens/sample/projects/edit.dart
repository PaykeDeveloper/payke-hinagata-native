// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
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

class ProjectEditScreen extends HookConsumerWidget {
  const ProjectEditScreen({
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
            url: ProjectUrl(slug: _projectSlug),
            reset: true,
          );
    }, [_divisionId, _projectSlug]);

    useEffect(() {
      Future.delayed(Duration.zero, initState);
      return null;
    }, [initState]);

    final onSubmit = useCallback<_OnSubmit>((input) async {
      final result =
          await ref.read(projectsStateProvider(_divisionId).notifier).merge(
                urlParams: ProjectUrl(slug: _projectSlug),
                data: input,
                useFormData: true,
              );
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
      return result;
    }, [_divisionId, _projectSlug]);

    final onPressedDelete = useCallback(() async {
      final result = await ref
          .read(projectsStateProvider(_divisionId).notifier)
          .deleteEntity(urlParams: ProjectUrl(slug: _projectSlug));
      switch (result) {
        case Success():
          await ref
              .read(routeStateProvider.notifier)
              .replace(BottomTab.projects, []);
        case Failure():
          break;
      }
    }, [_divisionId, _projectSlug]);

    final status = ref.watch(projectStatusSelector(_divisionId));
    final error = ref.watch(projectErrorSelector(_divisionId));
    final project = ref.watch(projectSelector(_divisionId));

    return _ProjectEdit(
      onSubmit: onSubmit,
      onPressedReload: initState,
      onPressedDelete: onPressedDelete,
      status: status,
      error: error,
      project: project,
    );
  }
}

typedef _OnSubmit = Future<StoreResult?> Function(Map<String, dynamic> data);

class _ProjectEdit extends StatelessWidget {
  const _ProjectEdit({
    required this.onSubmit,
    required this.onPressedReload,
    required this.onPressedDelete,
    required this.status,
    required this.error,
    required this.project,
  });

  final _OnSubmit onSubmit;
  final VoidCallback onPressedReload;
  final VoidCallback onPressedDelete;
  final StateStatus status;
  final StoreError? error;
  final Project? project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete project',
            onPressed: project == null ? null : onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
        child: Loader(
          status: status,
          child: ProjectForm(
            project: project,
            status: status,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}
