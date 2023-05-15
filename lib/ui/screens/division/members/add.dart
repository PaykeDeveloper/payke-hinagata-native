import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/common/roles/models/role.dart';
import 'package:native_app/store/state/domain/common/roles/selectors.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_input.dart';
import 'package:native_app/store/state/domain/division/members/models/members_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

import './widgets/form.dart';

class MemberAddPage extends Page {
  const MemberAddPage({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MemberAddScreen(divisionId: _divisionId),
    );
  }
}

class MemberAddScreen extends ConsumerWidget {
  const MemberAddScreen({super.key, required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<StoreResult?> onSubmit(MemberInput input) async {
      final result = await ref.read(membersStateProvider.notifier).addEntity(
          urlParams: MembersUrl(divisionId: _divisionId), data: input);
      if (result is Success) {
        Navigator.of(context).pop();
      }
      return result;
    }

    final status = ref.watch(membersStatusSelector);
    final error = ref.watch(membersErrorSelector);
    final users = ref.watch(usersSelector);
    final roles = ref.watch(memberRolesSelector);

    return MemberAdd(
      onSubmit: onSubmit,
      status: status,
      error: error,
      users: users,
      roles: roles,
    );
  }
}

typedef OnSubmit = Future<StoreResult?> Function(MemberInput input);

class MemberAdd extends StatefulWidget {
  const MemberAdd({
    super.key,
    required OnSubmit onSubmit,
    required StateStatus status,
    required StoreError? error,
    required List<User> users,
    required List<Role> roles,
  })  : _onSubmit = onSubmit,
        _status = status,
        _error = error,
        _users = users,
        _roles = roles;
  final OnSubmit _onSubmit;
  final StateStatus _status;
  final StoreError? _error;
  final List<User> _users;
  final List<Role> _roles;

  @override
  State<MemberAdd> createState() => _MemberAddState();
}

class _MemberAddState extends State<MemberAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add member'),
      ),
      body: ErrorWrapper(
        error: widget._error,
        child: Loader(
          status: widget._status,
          child: MemberForm(
            member: null,
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
