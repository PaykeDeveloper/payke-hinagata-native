// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/member.dart';
import './models/member_input.dart';
import './models/member_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class MembersState extends _$MembersState
    with
        EntitiesMixin<Member, MemberUrl, JsonGenerator, Member, void,
            JsonGenerator>,
        FetchEntitiesMixin<Member, MemberUrl, JsonGenerator, Member, void,
            JsonGenerator>,
        CreateEntitiesMixin<Member, MemberUrl, JsonGenerator, Member, void,
            JsonGenerator, MemberInput, JsonGenerator>,
        UpdateEntitiesMixin<Member, MemberUrl, JsonGenerator, Member, void,
            JsonGenerator, MemberInput, JsonGenerator>,
        DeleteEntitiesMixin<Member, MemberUrl, JsonGenerator, Member, void,
            JsonGenerator, JsonGenerator> {
  @override
  EntitiesState<Member, MemberUrl, JsonGenerator, Member, void, JsonGenerator>
      build(DivisionId divisionId) => buildDefault();

  @override
  BackendClient getBackendClient() => ref.read(backendClientProvider);

  @override
  String getEntitiesUrl(void url) =>
      '/api/v1/divisions/${divisionId.value}/members';

  @override
  String getEntityUrl(MemberUrl url) =>
      '/api/v1/divisions/${divisionId.value}/members/${url.id.value}';

  @override
  Member decodeEntities(Map<String, dynamic> json) => Member.fromJson(json);

  @override
  Member decodeEntity(Map<String, dynamic> json) => Member.fromJson(json);

  @override
  Member? convertToEntitiesEntity(Member entity) => entity;

  @override
  bool isTargetEntitiesEntity(MemberUrl urlParams, Member entity) =>
      urlParams.id == entity.id;
}
