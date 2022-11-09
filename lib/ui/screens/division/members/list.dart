import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/app/route/selectors.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/models/users_url.dart';
import 'package:native_app/store/state/domain/common/users/notifier.dart';
import 'package:native_app/store/state/domain/common/users/selectors.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member.dart';
import 'package:native_app/store/state/domain/division/members/models/member_id.dart';
import 'package:native_app/store/state/domain/division/members/models/members_url.dart';
import 'package:native_app/store/state/domain/division/members/notifier.dart';
import 'package:native_app/store/state/domain/division/members/selectors.dart';
import 'package:native_app/ui/navigation/params/members/add.dart';
import 'package:native_app/ui/navigation/params/members/detail.dart';
import 'package:native_app/ui/navigation/params/members/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class MemberListPage extends Page {
  const MemberListPage({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer;
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

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({
    required DivisionId divisionId,
    required VoidCallback openDrawer,
  })  : _divisionId = divisionId,
        _openDrawer = openDrawer;
  final DivisionId _divisionId;
  final VoidCallback _openDrawer;

  @override
  Widget build(BuildContext context) {
    final memberUrl = MembersUrl(divisionId: _divisionId);
    Future initState() async {
      await Future.wait([
        context
            .read<MembersNotifier>()
            .fetchEntitiesIfNeeded(url: memberUrl, reset: true),
        context
            .read<UsersNotifier>()
            .fetchEntitiesIfNeeded(url: const UsersUrl())
      ]);
    }

    Future onRefresh() async {
      await Future.wait([
        context.read<MembersNotifier>().fetchEntities(url: memberUrl),
        context
            .read<UsersNotifier>()
            .fetchEntitiesIfNeeded(url: const UsersUrl(), reset: true),
      ]);
    }

    void onPressedNew() {
      context
          .read<RouteStateNotifier>()
          .push(BottomTab.members, MemberAddParams(divisionId: _divisionId));
    }

    void onTapShow(MemberId memberId) {
      context.read<RouteStateNotifier>().push(
            BottomTab.members,
            MemberDetailParams(divisionId: _divisionId, memberId: memberId),
          );
    }

    void onPressedEdit(MemberId memberId) {
      context.read<RouteStateNotifier>().push(
            BottomTab.members,
            MemberEditParams(divisionId: _divisionId, memberId: memberId),
          );
    }

    bool checkRouteEmpty() =>
        memberParamsListSelector(context.read<RouteState>()).isEmpty;

    final error = context.select(membersErrorSelector);
    final members = context.select(membersSelector);
    final usersMap = context.select(usersMapSelector);

    return MemberList(
      openDrawer: _openDrawer,
      initState: initState,
      onRefresh: onRefresh,
      onPressedNew: onPressedNew,
      onTapShow: onTapShow,
      onPressedEdit: onPressedEdit,
      checkRouteEmpty: checkRouteEmpty,
      error: error,
      members: members,
      usersMap: usersMap,
    );
  }
}

class MemberList extends StatefulWidget {
  const MemberList({
    required VoidCallback openDrawer,
    required Function0<Future> initState,
    required Function0<Future> onRefresh,
    required VoidCallback onPressedNew,
    required Function1<MemberId, void> onTapShow,
    required Function1<MemberId, void> onPressedEdit,
    required Function0<bool> checkRouteEmpty,
    required StoreError? error,
    required List<Member> members,
    required Map<int, User> usersMap,
  })  : _openDrawer = openDrawer,
        _initState = initState,
        _onRefresh = onRefresh,
        _onPressedNew = onPressedNew,
        _onTapShow = onTapShow,
        _onPressedEdit = onPressedEdit,
        _checkRouteEmpty = checkRouteEmpty,
        _error = error,
        _members = members,
        _usersMap = usersMap;
  final VoidCallback _openDrawer;
  final Function0<Future> _initState;
  final Function0<Future> _onRefresh;
  final VoidCallback _onPressedNew;
  final Function1<MemberId, void> _onTapShow;
  final Function1<MemberId, void> _onPressedEdit;
  final Function0<bool> _checkRouteEmpty;
  final StoreError? _error;
  final List<Member> _members;
  final Map<int, User> _usersMap;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await widget._initState();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  void didUpdateWidget(covariant MemberList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._checkRouteEmpty()) {
      _initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget._onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: widget._error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading,
          child: RefreshIndicator(
            onRefresh: widget._onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget._members.length,
              itemBuilder: (context, index) {
                final member = widget._members[index];
                final user = widget._usersMap[member.userId.value]!;
                return _ListItem(
                  user: user,
                  onTapItem: () => widget._onTapShow(member.id),
                  onPressedEdit: () => widget._onPressedEdit(member.id),
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
