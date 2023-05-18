import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required StoreError error,
    VoidCallback? onPressedReload,
  })  : _error = error,
        _onPressedReload = onPressedReload;

  final StoreError _error;
  final VoidCallback? _onPressedReload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorWrapper(
        error: _error,
        onPressedReload: _onPressedReload,
        child: const Text(''),
      ),
    );
  }
}
