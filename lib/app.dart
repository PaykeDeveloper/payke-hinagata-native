import 'package:flutter/material.dart';
import 'package:native_app/providers/providers.dart';
import 'package:native_app/ui/routes.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: routes,
        initialRoute: initialRoute,
      ),
    );
  }
}
