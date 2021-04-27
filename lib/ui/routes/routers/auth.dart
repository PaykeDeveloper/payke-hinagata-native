import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:native_app/ui/pages/auth/login.dart';
import 'package:native_app/ui/pages/common/loading.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class AuthRouter extends HookWidget {
  void _setLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final notifier = context.read<LocaleNotifier>();
    notifier.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(Duration.zero, () {
        _setLocale(context);
      });
    }, []);

    final locale = context.watch<Locale?>();
    final token = context.watch<StoreState<BackendToken?>>();

    if (locale == null || token.status != StateStatus.done) {
      return LoadingScreen();
    }
    if (token.data == null) {
      return LoginScreen();
    }
    return MainRouter();
  }
}
