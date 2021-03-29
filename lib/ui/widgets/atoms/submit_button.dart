import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/base/models/store_state.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required VoidCallback? onPressed,
    StateStatus? status,
    String? label,
  })  : _onPressed = onPressed,
        _status = status,
        _label = label;

  final VoidCallback? _onPressed;
  final StateStatus? _status;
  final String? _label;

  @override
  Widget build(BuildContext context) {
    final label = _label ?? AppLocalizations.of(context)!.submit;
    return SizedBox(
      height: Theme.of(context).buttonTheme.height,
      child: ElevatedButton(
        onPressed: _status == StateStatus.started ? null : _onPressed,
        child: Text(label),
      ),
    );
  }
}
