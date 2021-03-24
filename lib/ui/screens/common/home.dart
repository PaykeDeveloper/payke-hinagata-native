import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/token.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final token = context.watch<EntityState<Token?>>().data;
    // ignore: prefer_function_declarations_over_variables

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Token: ${token?.value}'),
        ),
      ),
    );
  }
}
