import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:native_app/store/state/app/route/models/router.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_slug.dart';
import 'package:native_app/store/state/ui/division_id/notifier.dart';
import 'package:native_app/ui/navigation/params/projects/detail.dart';
import 'package:native_app/ui/screens/auth/login.dart';
import 'package:native_app/ui/screens/common/loading.dart';
import 'package:uni_links/uni_links.dart';

import 'main.dart';

class AuthRouter extends HookConsumerWidget {
  const AuthRouter({super.key});

  void _setLocale(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final notifier = ref.read(localeStateProvider.notifier);
    notifier.setLocale(locale);
  }

  Future<void> _handleUri(BuildContext context, WidgetRef ref, Uri? uri) async {
    if (uri == null || uri.path.isEmpty) {
      return;
    }
    if (uri.pathSegments.elementAtOrNull(0) == 'divisions') {
      final id = uri.pathSegments.elementAtOrNull(1)?.toIntOrNull();
      if (id != null) {
        final divisionId = DivisionId(id);
        await ref
            .read(divisionIdStateProvider.notifier)
            .setDivisionId(divisionId);

        if (uri.pathSegments.elementAtOrNull(2) == 'projects') {
          final notifier = ref.read(routeStateProvider.notifier);
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

  Future<void> _handleInitialUri(BuildContext context, WidgetRef ref) async {
    final uri = await getInitialUri();
    await _handleUri(context, ref, uri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(Duration.zero, () {
        _setLocale(context, ref);
        ref.read(backendTokenStateProvider.notifier).initialize();
      });
      return null;
    }, []);
    useEffect(() {
      _handleInitialUri(context, ref);
      if (!kIsWeb) {
        final sub =
            uriLinkStream.listen((uri) => _handleUri(context, ref, uri));
        return sub.cancel;
      }
      return null;
    }, []);

    final locale = ref.watch(localeStateProvider);
    final token = ref.watch(backendTokenStateProvider);

    if (locale == null || token.status != StateStatus.done) {
      return const LoadingScreen();
    }
    if (token.data == null) {
      return const LoginScreen();
    }
    return const MainRouter();
  }
}
