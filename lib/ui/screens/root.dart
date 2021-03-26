import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:native_app/ui/screens/auth/login.dart';
import 'package:native_app/ui/screens/common/home.dart';
import 'package:native_app/ui/screens/common/loading.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  void _setLocale() {
    final locale = Localizations.localeOf(context);
    final notifier = context.read<LocaleNotifier>();
    notifier.setLocale(locale);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _setLocale();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<Locale?>();
    final token = context.watch<StoreState<BackendToken?>>();

    if (locale == null || token.status != StateStatus.done) {
      return LoadingPage();
    }
    if (token.data == null) {
      return LoginPage();
    }
    return HomePage();
  }
}
