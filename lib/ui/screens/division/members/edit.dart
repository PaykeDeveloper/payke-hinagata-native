import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
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

import './widgets/form.dart';

class MemberEditPage extends Page {
  const MemberEditPage({
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId;
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

class MemberEditScreen extends HookConsumerWidget {
  const MemberEditScreen({
    super.key,
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId;
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = useCallback(() {
      ref
          .read(membersStateProvider.call(_divisionId).notifier)
          .fetchEntityIfNeeded(url: MemberUrl(id: _memberId), reset: true);
    }, [_divisionId, _memberId]);

    useEffect(() {
      Future.delayed(Duration.zero, initState);
      return null;
    }, [initState]);

    final onSubmit = useCallback<_OnSubmit>((input) async {
      final result = await ref
          .read(membersStateProvider.call(_divisionId).notifier)
          .mergeEntity(urlParams: MemberUrl(id: _memberId), data: input);
      switch (result) {
        case Success():
          Navigator.of(context).pop();
        case Failure():
          break;
      }
      return result;
    }, [_divisionId, _memberId]);

    final onPressedDelete = useCallback(() async {
      final result = await ref
          .read(membersStateProvider.call(_divisionId).notifier)
          .deleteEntity(urlParams: MemberUrl(id: _memberId));
      switch (result) {
        case Success():
          await ref
              .read(routeStateProvider.notifier)
              .replace(BottomTab.members, []);
        case Failure():
          break;
      }
    }, [_divisionId, _memberId]);

    final status = ref.watch(memberStatusSelector(_divisionId));
    final error = ref.watch(memberErrorSelector(_divisionId));
    final member = ref.watch(memberSelector(_divisionId));
    final users = ref.watch(usersSelector);
    final roles = ref.watch(memberRolesSelector);

    return _MemberEdit(
      onSubmit: onSubmit,
      onPressedReload: initState,
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

class _MemberEdit extends StatelessWidget {
  const _MemberEdit({
    required this.onSubmit,
    required this.onPressedReload,
    required this.onPressedDelete,
    required this.status,
    required this.error,
    required this.member,
    required this.users,
    required this.roles,
  });

  final _OnSubmit onSubmit;
  final VoidCallback onPressedReload;
  final VoidCallback onPressedDelete;
  final StateStatus status;
  final StoreError? error;
  final Member? member;
  final List<User> users;
  final List<Role> roles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit member'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete member',
            onPressed: member == null ? null : onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
        child: Loader(
          status: status,
          child: MemberForm(
            member: member,
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
