import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/app/route/selectors.dart';
import 'package:native_app/ui/screens/division/members/list.dart';

class MembersNavigator extends ConsumerWidget {
  const MembersNavigator({
    super.key,
    required GlobalKey<NavigatorState>? navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _navigatorKey = navigatorKey,
        _scaffoldKey = scaffoldKey;
  final GlobalKey<NavigatorState>? _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paramsList = ref.watch(memberParamsListSelector);
    return Navigator(
      key: _navigatorKey,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        final notifier = ref.read(routeStateProvider.notifier);
        notifier.pop(BottomTab.members);
        return true;
      },
      pages: [
        MemberListPage(openDrawer: _openDrawer),
        ...paramsList.map((p) => p.toPage()),
      ],
    );
  }
}
