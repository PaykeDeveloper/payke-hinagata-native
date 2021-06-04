// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/project.dart';
import './notifier.dart';

List<Project> projectsSelector(ProjectsState state) => state.entities;

StateStatus projectsStatusSelector(ProjectsState state) => state.entitiesStatus;

StoreError? projectsErrorSelector(ProjectsState state) => state.entitiesError;

Project? projectSelector(ProjectsState state) => state.entity;

StateStatus projectStatusSelector(ProjectsState state) => state.entityStatus;

StoreError? projectErrorSelector(ProjectsState state) => state.entityError;
