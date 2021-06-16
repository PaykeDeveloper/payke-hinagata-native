import 'package:flutter/material.dart';
import 'package:native_app/base/utils.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/common/roles/selectors.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/models/users_url.dart';
import 'package:native_app/store/state/domain/common/users/notifier.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/store/state/domain/division/members/models/members_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './add.dart';
import './detail.dart';
import './edit.dart';

class MemberListPage extends Page {
  const MemberListPage({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer,
        super(key: const ValueKey("memberListPage"));
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MemberListScreen(
        divisionId: _divisionId,
        openDrawer: _openDrawer,
      ),
    );
  }
}

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer;
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await context.read<MembersNotifier>().fetchEntitiesIfNeeded(
          url: MembersUrl(divisionId: widget._divisionId),
          reset: true,
        );
    await context
        .read<UsersNotifier>()
        .fetchEntitiesIfNeeded(url: const UsersUrl());
    setState(() {
      _loading = false;
    });
  }

  Future _onRefresh() async {
    await Future.wait([
      context
          .read<MembersNotifier>()
          .fetchEntities(url: MembersUrl(divisionId: widget._divisionId)),
      context
          .read<UsersNotifier>()
          .fetchEntitiesIfNeeded(url: const UsersUrl()),
    ]);
  }

  void _onPressedNew() {
    context
        .read<RouteStateNotifier>()
        .push(BottomTab.members, MemberAddPage(divisionId: widget._divisionId));
  }

  void _onTapShow(MemberId memberId) {
    context.read<RouteStateNotifier>().push(
          BottomTab.members,
          MemberDetailPage(
            divisionId: widget._divisionId,
            memberId: memberId,
          ),
        );
  }

  void _onPressedEdit(MemberId memberId) {
    context.read<RouteStateNotifier>().push(
          BottomTab.members,
          MemberEditPage(
            divisionId: widget._divisionId,
            memberId: memberId,
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
  void didUpdateWidget(covariant MemberListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (context.read<RouteState>().memberPages.isEmpty) {
      _initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = context.select(membersSelector);
    final error = context.select(membersErrorSelector);
    final users = context.select(usersSelector);
    final isUsersLoading = context.select(usersStatusSelector).isLoading();
    final usersMap = convertListToMap(users, (User user) => user.id.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading && isUsersLoading,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final user = usersMap[member.id.value]!;
                return _ListItem(
                  user: user,
                  onTapItem: () => _onTapShow(member.id),
                  onPressedEdit: () => _onPressedEdit(member.id),
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
    required User user,
    required GestureTapCallback onTapItem,
    required VoidCallback onPressedEdit,
  })  : _user = user,
        _onTapItem = onTapItem,
        _onPressedEdit = onPressedEdit;

  final User _user;
  final GestureTapCallback _onTapItem;
  final VoidCallback _onPressedEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: _onTapItem,
        leading: Text('${_user.id.value}'),
        title: Text(_user.name),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _onPressedEdit,
        ),
      ),
    );
  }
}
