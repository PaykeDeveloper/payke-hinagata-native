import 'package:flutter/material.dart';
import 'package:native_app/models/app/provider_state.dart';
import 'package:native_app/models/app/token.dart';
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
      providers: getProviders(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<ProviderState<Token?>>(
          builder: (context, value, child) {
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
