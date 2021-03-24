import 'package:flutter/material.dart';
import 'package:native_app/base/api/client.dart';
import 'package:native_app/models/app/provider_state.dart';
import 'package:native_app/models/app/token.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final token = context.watch<ProviderState<Token?>>().data;
    // ignore: prefer_function_declarations_over_variables

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Client ${context.read<ApiClient>().token}')));
          },
          child: Text('Token: ${token?.value}'),
        ),
      ),
    );
  }
}
