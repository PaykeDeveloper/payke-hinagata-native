import 'package:flutter/material.dart';
import 'package:native_app/providers/app/token.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text('token: ${context.watch<TokenProvider>().token?.value}'),
      ),
    );
  }
}
