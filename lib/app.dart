import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/providers.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/ui/routes.dart';
import 'package:native_app/ui/screens/auth/login.dart';
import 'package:native_app/ui/screens/common/home.dart';
import 'package:native_app/ui/screens/common/loading.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer<StoreState<BackendToken?>>(
          builder: (context, value, child) {
            final locale = Localizations.localeOf(context);
            debugPrint(locale.toString());
            if (value.status != StateStatus.done) {
              return LoadingPage();
            }
            if (value.data == null) {
              return LoginPage();
            }
            return HomePage();
          },
        ),
        routes: routes,
      ),
    );
  }
}
