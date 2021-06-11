import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/common/roles/selectors.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
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

class MemberEditScreen extends StatefulWidget {
  const MemberEditScreen({
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId;
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  _MemberEditScreenState createState() => _MemberEditScreenState();
}

class _MemberEditScreenState extends State<MemberEditScreen> {
  Future _initState() async {
    await context
        .read<MembersNotifier>()
        .fetchEntityIfNeeded(url: _getMemberUrl(), reset: true);
  }

  Future<StoreResult?> _onSubmit(Map<String, dynamic> input) async {
    final result = await context
        .read<MembersNotifier>()
        .merge(urlParams: _getMemberUrl(), data: input, useFormData: true);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  Future _onPressedDelete() async {
    final result = await context
        .read<MembersNotifier>()
        .deleteEntity(urlParams: _getMemberUrl());
    if (result is Success) {
      await context.read<RouteStateNotifier>().replace(BottomTab.members, []);
    }
  }

  MemberUrl _getMemberUrl() => MemberUrl(
        divisionId: widget._divisionId,
        id: widget._memberId,
      );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final member = context.select(memberSelector);
    final error = context.select(memberErrorSelector);
    final status = context.select(memberStatusSelector);
    final users = context.select(usersSelector);
    final roles = context.select(memberRolesSelector);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit member'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete member',
            onPressed: member == null ? null : _onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: MemberForm(
            member: member,
            users: users,
            roles: roles,
            status: status,
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
