import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/member.dart';
import './notifier.dart';

List<Member> membersSelector(MembersState state) => state.entities;

StateStatus membersStatusSelector(MembersState state) => state.entitiesStatus;

StoreError? membersErrorSelector(MembersState state) => state.entitiesError;

Member? memberSelector(MembersState state) => state.entity;

StateStatus memberStatusSelector(MembersState state) => state.entityStatus;

StoreError? memberErrorSelector(MembersState state) => state.entityError;
