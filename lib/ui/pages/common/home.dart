import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    VoidCallback? onPressedDrawerMenu,
  }) : _onPressedDrawerMenu = onPressedDrawerMenu;
  final VoidCallback? _onPressedDrawerMenu;

  @override
  Widget build(BuildContext context) {
    final authenticated = context.watch<BackendClient>().authenticated;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _onPressedDrawerMenu,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Auth: $authenticated'),
            ));
          },
          child: Text('Auth: $authenticated'),
        ),
      ),
    );
  }
}
