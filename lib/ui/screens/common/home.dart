import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/api_client.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text('Client')));
          },
          child: Text('Auth: ${context.watch<ApiClient>().authenticated}'),
        ),
      ),
    );
  }
}
