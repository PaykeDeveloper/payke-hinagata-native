import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class MemberDetailScreen extends HookConsumerWidget {
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
    final initState = useCallback(() {
      ref
          .read(membersStateProvider.call(_divisionId).notifier)
          .fetchEntityIfNeeded(url: MemberUrl(id: _memberId), reset: true);
    }, [_divisionId, _memberId]);

    useEffect(() {
      Future.microtask(initState);
      return null;
    }, [initState]);

    final onPressedEdit = useCallback(() {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.members,
            MemberEditParams(divisionId: _divisionId, memberId: _memberId),
          );
    }, [_divisionId, _memberId]);

    final status = ref.watch(memberStatusSelector(_divisionId));
    final error = ref.watch(memberErrorSelector(_divisionId));
    final member = ref.watch(memberSelector(_divisionId));

    return _MemberDetail(
      onPressedReload: initState,
      onPressedEdit: onPressedEdit,
      status: status,
      error: error,
      member: member,
    );
  }
}

class _MemberDetail extends StatelessWidget {
  const _MemberDetail({
    required this.onPressedReload,
    required this.onPressedEdit,
    required this.status,
    required this.error,
    required this.member,
  });

  final VoidCallback onPressedReload;
  final VoidCallback onPressedEdit;
  final StateStatus status;
  final StoreError? error;
  final Member? member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit member',
            onPressed: member == null ? null : onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
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
