// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/member.dart';
import './models/member_input.dart';
import './models/member_url.dart';
import './models/members_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class MembersState extends _$MembersState
    with
        EntitiesMixin<Member, MemberUrl, Member, MembersUrl>,
        FetchEntitiesMixin<Member, MemberUrl, Member, MembersUrl>,
        CreateEntitiesMixin<Member, MemberUrl, Member, MembersUrl, MemberInput>,
        UpdateEntitiesMixin<Member, MemberUrl, Member, MembersUrl, MemberInput>,
        DeleteEntitiesMixin<Member, MemberUrl, Member, MembersUrl> {
  @override
  EntitiesState<Member, MemberUrl, Member, MembersUrl> build() =>
      buildDefault();

  @override
  String getEntitiesUrl(MembersUrl url) =>
      '/api/v1/divisions/${url.divisionId.value}/members';

  @override
  String getEntityUrl(MemberUrl url) =>
      '/api/v1/divisions/${url.divisionId.value}/members/${url.id.value}';

  @override
  Member decodeEntities(Map<String, dynamic> json) => Member.fromJson(json);

  @override
  Member decodeEntity(Map<String, dynamic> json) => Member.fromJson(json);
}
