// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/project.dart';
import './models/project_input.dart';
import './models/project_url.dart';
import './models/projects_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class ProjectsState extends _$ProjectsState
    with
        EntitiesMixin<Project, ProjectUrl, Project, ProjectsUrl>,
        FetchEntitiesMixin<Project, ProjectUrl, Project, ProjectsUrl>,
        CreateEntitiesMixin<Project, ProjectUrl, Project, ProjectsUrl,
            ProjectInput>,
        UpdateEntitiesMixin<Project, ProjectUrl, Project, ProjectsUrl,
            ProjectInput>,
        DeleteEntitiesMixin<Project, ProjectUrl, Project, ProjectsUrl> {
  @override
  EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> build() =>
      buildDefault();

  @override
  String getEntitiesUrl(ProjectsUrl url) =>
      '/api/v1/divisions/${url.divisionId.value}/projects';

  @override
  String getEntityUrl(ProjectUrl url) =>
      '/api/v1/divisions/${url.divisionId.value}/projects/${url.slug.value}';

  @override
  Project decodeEntities(Map<String, dynamic> json) => Project.fromJson(json);

  @override
  Project decodeEntity(Map<String, dynamic> json) => Project.fromJson(json);
}
