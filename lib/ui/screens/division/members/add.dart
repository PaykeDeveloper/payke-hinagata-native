import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/domain/common/roles/selectors.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/members_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './widgets/form.dart';

class MemberAddPage extends Page {
  MemberAddPage({required DivisionId divisionId})
      : _divisionId = divisionId,
        super(key: ValueKey("memberAddPage-${divisionId.value}"));
  final DivisionId _divisionId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MemberAddScreen(divisionId: _divisionId),
    );
  }
}

class MemberAddScreen extends StatefulWidget {
  const MemberAddScreen({required DivisionId divisionId})
      : _divisionId = divisionId;
  final DivisionId _divisionId;

  @override
  _MemberAddScreenState createState() => _MemberAddScreenState();
}

class _MemberAddScreenState extends State<MemberAddScreen> {
  Future<StoreResult?> _onSubmit(Map<String, dynamic> input) async {
    final result = await context.read<MembersNotifier>().add(
        urlParams: MembersUrl(divisionId: widget._divisionId),
        data: input,
        useFormData: false);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select(membersErrorSelector);
    final status = context.select(membersStatusSelector);
    final users = context.select(usersSelector);
    final roles = context.select(memberRolesSelector);

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
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
