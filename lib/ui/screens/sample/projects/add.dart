// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_input.dart';
import 'package:native_app/store/state/domain/sample/projects/models/projects_url.dart';
import 'package:native_app/store/state/domain/sample/projects/notifier.dart';
import 'package:native_app/store/state/domain/sample/projects/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './widgets/form.dart';

class ProjectAddPage extends Page {
  ProjectAddPage({required DivisionId divisionId})
      : _divisionId = divisionId,
        super(key: ValueKey("projectAddPage-${divisionId.value}"));
  final DivisionId _divisionId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => ProjectAddScreen(divisionId: _divisionId),
    );
  }
}

class ProjectAddScreen extends StatefulWidget {
  const ProjectAddScreen({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  _ProjectAddScreenState createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen> {
  Future<StoreResult?> _onSubmit(ProjectInput input) async {
    final result = await context.read<ProjectsNotifier>().addEntity(
        urlParams: ProjectsUrl(divisionId: widget._divisionId), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select(projectsErrorSelector);
    final status = context.select(projectsStatusSelector);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add project'),
      ),
      body: ErrorWrapper(
        error: error,
        child: Loader(
          status: status,
          child: ProjectForm(
            project: null,
            status: status,
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
