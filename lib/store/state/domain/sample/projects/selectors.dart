import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/project.dart';
import './models/project_url.dart';
import './models/projects_url.dart';

List<Project> projectsSelector(
        EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> state) =>
    state.entities;

StateStatus projectsStatusSelector(
        EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> state) =>
    state.entitiesStatus;

StoreError? projectsErrorSelector(
        EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> state) =>
    state.entitiesError;

Project? projectSelector(
        EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> state) =>
    state.entity;

StateStatus projectStatusSelector(
        EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> state) =>
    state.entityStatus;

StoreError? projectErrorSelector(
        EntitiesState<Project, ProjectUrl, Project, ProjectsUrl> state) =>
    state.entityError;
