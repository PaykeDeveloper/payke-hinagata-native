import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';

import './models/member.dart';
import './models/member_input.dart';
import './models/member_url.dart';
import './models/members_url.dart';

typedef MembersState = EntitiesState<Member, MemberUrl, Member, MembersUrl>;

class MembersNotifier extends EntitiesNotifier<Member, MemberUrl, Member,
    MembersUrl, MemberInput, MemberInput> {
  MembersNotifier(MembersState state) : super(state);

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
