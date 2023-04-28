import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './ui/navigation/routers/auth.dart';
import './ui/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
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
