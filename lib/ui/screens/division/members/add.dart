import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class MemberAddScreen extends HookConsumerWidget {
  const MemberAddScreen({super.key, required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSubmit = useCallback<_OnSubmit>((input) async {
      final result = await ref
          .read(membersStateProvider(_divisionId).notifier)
          .addEntity(urlParams: null, data: input);
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
      return result;
    }, [_divisionId]);

    final status = ref.watch(membersStatusSelector(_divisionId));
    final error = ref.watch(membersErrorSelector(_divisionId));
    final users = ref.watch(usersSelector);
    final roles = ref.watch(memberRolesSelector);

    return _MemberAdd(
      onSubmit: onSubmit,
      status: status,
      error: error,
      users: users,
      roles: roles,
    );
  }
}

typedef _OnSubmit = Future<StoreResult?> Function(MemberInput input);

class _MemberAdd extends StatelessWidget {
  const _MemberAdd({
    required this.onSubmit,
    required this.status,
    required this.error,
    required this.users,
    required this.roles,
  });

  final _OnSubmit onSubmit;
  final StateStatus status;
  final StoreError? error;
  final List<User> users;
  final List<Role> roles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add member'),
      ),
      body: ErrorWrapper(
        error: error,
        child: Loader(
          status: status,
          child: MemberForm(
            member: null,
            users: users,
            roles: roles,
            status: status,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}
