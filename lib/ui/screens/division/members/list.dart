import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/notifier.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/members/models/member.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/navigation/params/members/add.dart';
import 'package:native_app/ui/navigation/params/members/detail.dart';
import 'package:native_app/ui/navigation/params/members/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';

class MemberListPage extends Page {
  const MemberListPage({required VoidCallback openDrawer})
      : _openDrawer = openDrawer;
  final VoidCallback _openDrawer;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MemberListScreen(openDrawer: _openDrawer),
    );
  }
}

class MemberListScreen extends HookConsumerWidget {
  const MemberListScreen({
    super.key,
    required VoidCallback openDrawer,
  }) : _openDrawer = openDrawer;
  final VoidCallback _openDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divisionId = ref.watch(divisionIdSelector)!;

    final initState = useCallback(() async {
      await Future.wait([
        ref
            .read(membersStateProvider.call(divisionId).notifier)
            .fetchEntitiesIfNeeded(url: null, reset: true),
        ref.read(usersStateProvider.notifier).fetchEntitiesIfNeeded(url: null)
      ]);
    }, [divisionId]);

    useEffect(() {
      Future.microtask(initState);
      return null;
    }, [initState]);

    final onRefresh = useCallback(() async {
      await Future.wait([
        ref
            .read(membersStateProvider.call(divisionId).notifier)
            .fetchEntities(url: null, silent: true),
        ref
            .read(usersStateProvider.notifier)
            .fetchEntities(url: null, silent: true),
      ]);
    }, [divisionId]);

    final onPressedNew = useCallback(() {
      ref
          .read(routeStateProvider.notifier)
          .push(BottomTab.members, MemberAddParams(divisionId: divisionId));
    }, [divisionId]);

    final onPressedEdit = useCallback((MemberId memberId) {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.members,
            MemberEditParams(divisionId: divisionId, memberId: memberId),
          );
    }, [divisionId]);

    final onTapShow = useCallback((MemberId memberId) {
      ref.read(routeStateProvider.notifier).push(
            BottomTab.members,
            MemberDetailParams(divisionId: divisionId, memberId: memberId),
          );
    }, [divisionId]);

    final error = ref.watch(membersErrorSelector(divisionId));
    final members = ref.watch(membersSelector(divisionId));
    final usersMap = ref.watch(usersMapSelector);

    return _MemberList(
      openDrawer: _openDrawer,
      onPressedReload: initState,
      onRefresh: onRefresh,
      onPressedNew: onPressedNew,
      onPressedEdit: onPressedEdit,
      onTapShow: onTapShow,
      error: error,
      members: members,
      usersMap: usersMap,
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    required this.openDrawer,
    required this.onPressedReload,
    required this.onRefresh,
    required this.onPressedNew,
    required this.onPressedEdit,
    required this.onTapShow,
    required this.error,
    required this.members,
    required this.usersMap,
  });

  final VoidCallback openDrawer;
  final Function0<Future> onPressedReload;
  final Function0<Future> onRefresh;
  final VoidCallback onPressedNew;
  final Function1<MemberId, void> onTapShow;
  final Function1<MemberId, void> onPressedEdit;
  final StoreError? error;
  final List<Member> members;
  final Map<int, User> usersMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "members",
        onPressed: onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: onPressedReload,
        child: Loader(
          loading: false,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final user = usersMap[member.userId.value]!;
                return _ListItem(
                  user: user,
                  onTapItem: () => onTapShow(member.id),
                  onPressedEdit: () => onPressedEdit(member.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.user,
    required this.onTapItem,
    required this.onPressedEdit,
  });

  final User user;
  final GestureTapCallback onTapItem;
  final VoidCallback onPressedEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTapItem,
        leading: Text('${user.id.value}'),
        title: Text(user.name),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onPressedEdit,
        ),
      ),
    );
  }
}
