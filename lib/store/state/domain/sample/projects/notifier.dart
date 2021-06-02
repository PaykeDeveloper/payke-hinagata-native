// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';

import './models/project.dart';
import './models/project_input.dart';
import './models/project_url.dart';
import './models/projects_url.dart';

typedef ProjectsState
    = EntitiesState<Project, ProjectUrl, Project, ProjectsUrl>;

class ProjectsNotifier extends EntitiesNotifier<Project, ProjectUrl, Project,
    ProjectsUrl, ProjectInput, ProjectInput> {
  ProjectsNotifier(ProjectsState state) : super(state);

  @override
  String getEntitiesUrl(ProjectsUrl url) =>
      'api/v1/divisions/${url.divisionId.value}/projects/';

  @override
  String getEntityUrl(ProjectUrl url) =>
      'api/v1/divisions/${url.divisionId.value}/projects/${url.id.value}/';

  @override
  Project decodeEntities(Map<String, dynamic> json) => Project.fromJson(json);

  @override
  Project decodeEntity(Map<String, dynamic> json) => Project.fromJson(json);
}
