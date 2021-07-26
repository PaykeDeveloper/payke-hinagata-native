import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/common/roles/models/role.dart';
import 'package:native_app/store/state/domain/common/roles/selectors.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_input.dart';
import 'package:native_app/store/state/domain/division/members/models/member_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './widgets/form.dart';

class MemberEditPage extends Page {
  MemberEditPage({
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId,
        super(
            key: ValueKey(
                "memberEditPage-${divisionId.value}-${memberId.value}"));
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MemberEditScreen(
        divisionId: _divisionId,
        memberId: _memberId,
      ),
    );
  }
}

class MemberEditScreen extends StatelessWidget {
  const MemberEditScreen({
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId;
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  Widget build(BuildContext context) {
    final memberUrl = MemberUrl(divisionId: _divisionId, id: _memberId);

    Future<StoreResult?> onSubmit(MemberInput input) async {
      final result = await context
          .read<MembersNotifier>()
          .mergeEntity(urlParams: memberUrl, data: input);
      if (result is Success) {
        Navigator.of(context).pop();
      }
      return result;
    }

    void initState() {
      context
          .read<MembersNotifier>()
          .fetchEntityIfNeeded(url: memberUrl, reset: true);
    }

    Future onPressedDelete() async {
      final result = await context
          .read<MembersNotifier>()
          .deleteEntity(urlParams: memberUrl);
      if (result is Success) {
        await context.read<RouteStateNotifier>().replace(BottomTab.members, []);
      }
    }

    final status = context.select(memberStatusSelector);
    final error = context.select(memberErrorSelector);
    final member = context.select(memberSelector);
    final users = context.select(usersSelector);
    final roles = context.select(memberRolesSelector);

    return MemberEdit(
      onSubmit: onSubmit,
      initState: initState,
      onPressedDelete: onPressedDelete,
      status: status,
      error: error,
      member: member,
      users: users,
      roles: roles,
    );
  }
}

typedef _OnSubmit = Future<StoreResult?> Function(MemberInput input);

class MemberEdit extends StatefulWidget {
  const MemberEdit({
    required _OnSubmit onSubmit,
    required VoidCallback initState,
    required VoidCallback onPressedDelete,
    required StateStatus status,
    required StoreError? error,
    required Member? member,
    required List<User> users,
    required List<Role> roles,
  })  : _onSubmit = onSubmit,
        _initState = initState,
        _onPressedDelete = onPressedDelete,
        _status = status,
        _error = error,
        _member = member,
        _users = users,
        _roles = roles;
  final _OnSubmit _onSubmit;
  final VoidCallback _initState;
  final VoidCallback _onPressedDelete;
  final StateStatus _status;
  final StoreError? _error;
  final Member? _member;
  final List<User> _users;
  final List<Role> _roles;

  @override
  _MemberEditState createState() => _MemberEditState();
}

class _MemberEditState extends State<MemberEdit> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget._initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit member'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete member',
            onPressed: widget._member == null ? null : widget._onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: widget._initState,
        child: Loader(
          status: widget._status,
          child: MemberForm(
            member: widget._member,
            users: widget._users,
            roles: widget._roles,
            status: widget._status,
            onSubmit: widget._onSubmit,
          ),
        ),
      ),
    );
  }
}
