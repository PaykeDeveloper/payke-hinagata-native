import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/providers.dart';
import 'package:provider/provider.dart';

import './ui/root.dart';
import './ui/theme.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: getTheme(),
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Root(),
      ),
    );
  }
}
