import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/base/api/client.dart';
import 'package:native_app/models/app/language.dart';
import 'package:native_app/models/app/state.dart';
import 'package:native_app/models/app/token.dart';
import 'package:native_app/providers/app/api_client.dart';
import 'package:native_app/providers/app/language.dart';
import 'package:native_app/providers/app/login.dart';
import 'package:native_app/providers/app/token.dart';
import 'package:native_app/providers/providers.dart';
import 'package:native_app/ui/pages/common/home.dart';
import 'package:native_app/ui/pages/common/loading.dart';
import 'package:native_app/ui/pages/common/login.dart';
import 'package:native_app/ui/routes.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StateNotifierProvider<TokenProvider, Token?>(
            create: (context) => TokenProvider()),
        StateNotifierProvider<LanguageProvider, Language?>(
            create: (context) => LanguageProvider()),
        StateNotifierProvider<ApiClientProvider, ApiClient>(
            create: (context) => ApiClientProvider()),
        StateNotifierProvider<LoginProvider, bool>(
            create: (context) => LoginProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<Token?>(
          builder: (context, value, child) {
            // if (value ) {
            //   return LoadingPage();
            // }
            if (value == null) {
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
