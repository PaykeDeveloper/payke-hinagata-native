import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/navigation/params/members/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

class MemberDetailPage extends Page {
  const MemberDetailPage({
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
      builder: (context) => MemberDetailScreen(
        divisionId: _divisionId,
        memberId: _memberId,
      ),
    );
  }
}

class MemberDetailScreen extends ConsumerWidget {
  const MemberDetailScreen({
    super.key,
    required DivisionId divisionId,
    required MemberId memberId,
  })  : _divisionId = divisionId,
        _memberId = memberId;
  final DivisionId _divisionId;
  final MemberId _memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void initState() {
      ref.read(membersStateProvider.notifier).fetchEntityIfNeeded(
          url: MemberUrl(divisionId: _divisionId, id: _memberId), reset: true);
    }

    void onPressedEdit() {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.members,
            MemberEditParams(divisionId: _divisionId, memberId: _memberId),
          );
    }

    final status = ref.watch(memberStatusSelector);
    final error = ref.watch(memberErrorSelector);
    final member = ref.watch(memberSelector);

    return MemberDetail(
      initState: initState,
      onPressedEdit: onPressedEdit,
      status: status,
      error: error,
      member: member,
    );
  }
}

class MemberDetail extends StatefulWidget {
  const MemberDetail({
    super.key,
    required VoidCallback initState,
    required VoidCallback onPressedEdit,
    required StateStatus status,
    required StoreError? error,
    required Member? member,
  })  : _initState = initState,
        _onPressedEdit = onPressedEdit,
        _status = status,
        _error = error,
        _member = member;
  final VoidCallback _initState;
  final VoidCallback _onPressedEdit;
  final StateStatus _status;
  final StoreError? _error;
  final Member? _member;

  @override
  State<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
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
        title: const Text('Member detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit member',
            onPressed: widget._member == null ? null : widget._onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: widget._initState,
        child: Loader(
          status: widget._status,
          child: Center(
            child: Text('Name: ${widget._member?.id.value}'),
          ),
        ),
      ),
    );
  }
}
