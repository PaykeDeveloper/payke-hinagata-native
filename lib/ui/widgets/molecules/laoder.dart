import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_state.dart';

class Loader extends StatelessWidget {
  const Loader({
    required Widget child,
    bool? loading,
    StateStatus? status,
  })  : _child = child,
        _loading = loading,
        _status = status;

  final Widget _child;
  final bool? _loading;
  final StateStatus? _status;

  @override
  Widget build(BuildContext context) {
    if (_loading == true || _status == StateStatus.started) {
      return const Center(child: CircularProgressIndicator());
    }

    return _child;
  }
}
