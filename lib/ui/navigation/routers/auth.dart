import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:native_app/ui/navigation/params/projects/detail.dart';
import 'package:native_app/ui/screens/auth/login.dart';
import 'package:native_app/ui/screens/common/loading.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'main.dart';

class AuthRouter extends HookWidget {
  const AuthRouter({super.key});

  void _setLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final notifier = context.read<LocaleNotifier>();
    notifier.setLocale(locale);
  }

  Future<void> _handleUri(BuildContext context, Uri? uri) async {
    if (uri == null || uri.path.isEmpty) {
      return;
    }
    if (uri.pathSegments.elementAtOrNull(0) == 'divisions') {
      final id = uri.pathSegments.elementAtOrNull(1)?.toIntOrNull();
      if (id != null) {
        final divisionId = DivisionId(id);
        await context.read<DivisionIdNotifier>().setDivisionId(divisionId);

        if (uri.pathSegments.elementAtOrNull(2) == 'projects') {
          final notifier = context.read<RouteStateNotifier>();
          await notifier.changeIndex(BottomTab.projects);

          final slug = uri.pathSegments.elementAtOrNull(3);
          if (slug != null) {
            final projectSlug = ProjectSlug(slug);
            await notifier.replace(BottomTab.projects, [
              ProjectDetailParams(
                divisionId: divisionId,
                projectSlug: projectSlug,
              ),
            ]);
          } else {
            await notifier.replace(BottomTab.projects, []);
          }
        }
      }
    }
  }

  Future<void> _handleInitialUri(BuildContext context) async {
    final uri = await getInitialUri();
    await _handleUri(context, uri);
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(Duration.zero, () {
        _setLocale(context);
      });
      return null;
    }, []);
    useEffect(() {
      _handleInitialUri(context);
      if (!kIsWeb) {
        final sub = uriLinkStream.listen((uri) => _handleUri(context, uri));
        return sub.cancel;
      }
      return null;
    }, []);

    final locale = context.watch<Locale?>();
    final token = context.watch<BackendTokenState>();

    if (locale == null || token.status != StateStatus.done) {
      return const LoadingScreen();
    }
    if (token.data == null) {
      return const LoginScreen();
    }
    return const MainRouter();
  }
}
