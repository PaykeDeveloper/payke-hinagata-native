// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/project.dart';
import './models/project_input.dart';
import './models/project_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class ProjectsState extends _$ProjectsState
    with
        EntitiesMixin<Project, ProjectUrl, JsonGenerator, Project, void,
            JsonGenerator>,
        FetchEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project, void,
            JsonGenerator>,
        CreateEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project, void,
            JsonGenerator, ProjectInput, JsonGenerator>,
        UpdateEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project, void,
            JsonGenerator, ProjectInput, JsonGenerator>,
        DeleteEntitiesMixin<Project, ProjectUrl, JsonGenerator, Project, void,
            JsonGenerator, JsonGenerator> {
  @override
  EntitiesState<Project, ProjectUrl, JsonGenerator, Project, void,
      JsonGenerator> build(DivisionId divisionId) => buildDefault();

  @override
  BackendClient getBackendClient() => ref.read(backendClientProvider);

  @override
  String getEntitiesUrl(void url) =>
      '/api/v1/divisions/${divisionId.value}/projects';

  @override
  String getEntityUrl(ProjectUrl url) =>
      '/api/v1/divisions/${divisionId.value}/projects/${url.slug.value}';

  @override
  Project decodeEntities(Map<String, dynamic> json) => Project.fromJson(json);

  @override
  Project decodeEntity(Map<String, dynamic> json) => Project.fromJson(json);

  @override
  Project? convertToEntitiesEntity(Project entity) => entity;

  @override
  bool isTargetEntitiesEntity(ProjectUrl urlParams, Project entity) =>
      urlParams.slug == entity.slug;
}
