import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/screens/division/Members/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

import './edit.dart';

class MemberDetailPage extends Page {
  MemberDetailPage({
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId,
        super(
            key: ValueKey(
                "memberDetailPage-${divisionId.value}-${memberId.value}"));
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MemberDetailScreen(
        divisionId: _divisionId,
        memberId: _memberId,
      ),
    );
  }
}

class MemberDetailScreen extends StatefulWidget {
  const MemberDetailScreen({
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId;
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  _MemberDetailScreenState createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  Future _initState() async {
    await context.read<MembersNotifier>().fetchEntityIfNeeded(
        url: MemberUrl(
            divisionId: widget._divisionId, id: widget._memberId),
        reset: true);
  }

  void _onPressedEdit() {
    context.read<RouteStateNotifier>().push(
          BottomTab.members,
          MemberEditPage(
            divisionId: widget._divisionId,
            memberId: widget._memberId,
          ),
        );
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit member',
            onPressed: member == null ? null : _onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: Center(
            child: Text('Name: ${member?.id.value}'),
          ),
        ),
      ),
    );
  }
}
