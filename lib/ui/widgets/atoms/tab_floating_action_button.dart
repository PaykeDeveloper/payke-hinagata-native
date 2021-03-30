import 'package:flutter/material.dart';

class TabFloatingActionButton extends StatelessWidget {
  const TabFloatingActionButton({
    required VoidCallback? onPressed,
    required Widget? child,
  })   : _onPressed = onPressed,
        _child = child;

  final VoidCallback? _onPressed;
  final Widget? _child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: FloatingActionButton(
        onPressed: _onPressed,
        child: _child,
      ),
    );
  }
}
