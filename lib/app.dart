import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/base/api_client.dart';
import 'package:native_app/store/providers.dart';
import 'package:provider/provider.dart';

import './ui/navigation/routers/auth.dart';
import './ui/theme.dart';

class App extends StatelessWidget {
  const App({DioInspector? backendInspector})
      : _backendInspector = backendInspector;

  final DioInspector? _backendInspector;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(backendInspector: _backendInspector),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: getTheme(),
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AuthRouter(),
      ),
    );
  }
}
