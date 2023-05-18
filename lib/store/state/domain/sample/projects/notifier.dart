// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/project.dart';
import './models/project_input.dart';
import './models/project_url.dart';
import './models/projects_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class ProjectsState extends _$ProjectsState
    with
        EntitiesMixin<Project, ProjectUrl, JsonGenerator, Project, ProjectsUrl,
            JsonGenerator>,
        FetchEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project,
            ProjectsUrl, JsonGenerator>,
        CreateEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project,
            ProjectsUrl, JsonGenerator, ProjectInput, JsonGenerator>,
        UpdateEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project,
            ProjectsUrl, JsonGenerator, ProjectInput, JsonGenerator>,
        DeleteEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project,
            ProjectsUrl, JsonGenerator, JsonGenerator> {
  @override
  EntitiesState<Project, ProjectUrl, JsonGenerator, Project, ProjectsUrl,
      JsonGenerator> build() => buildDefault();

  @override
  BackendClient getBackendClient() => ref.read(backendClientProvider);

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
