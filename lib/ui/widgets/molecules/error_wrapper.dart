import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/base/models/state_error.dart';
import 'package:native_app/store/state/app/logout/notifier.dart';
import 'package:native_app/ui/extensions/state_error.dart';
import 'package:provider/provider.dart';

class ErrorWrapper extends StatelessWidget {
  const ErrorWrapper({
    required Widget child,
    required StateError? error,
    VoidCallback? onPressedReload,
  })  : _child = child,
        _error = error,
        _onPressedReload = onPressedReload;

  final Widget _child;
  final StateError? _error;
  final VoidCallback? _onPressedReload;

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      final String message = error.getContextMessage(context);
      final buttonText = error.map(
        sendTimeout: (_) => AppLocalizations.of(context)!.reload,
        requestCancelled: (_) => AppLocalizations.of(context)!.reload,
        unauthorisedRequest: (_) => AppLocalizations.of(context)!.logout,
        badRequest: (_) => AppLocalizations.of(context)!.reload,
        notFound: (_) => AppLocalizations.of(context)!.reload,
        requestTimeout: (_) => AppLocalizations.of(context)!.reload,
        serviceUnavailable: (_) => AppLocalizations.of(context)!.reload,
        noInternetConnection: (_) => AppLocalizations.of(context)!.reload,
        unexpectedError: (_) => AppLocalizations.of(context)!.reload,
      );
      final onPressed = error.map(
        sendTimeout: (_) => _onPressedReload,
        requestCancelled: (_) => _onPressedReload,
        unauthorisedRequest: (_) {
          final notifier = context.read<LogoutNotifier>();
          notifier.logout();
        },
        badRequest: (_) => _onPressedReload,
        notFound: (_) => _onPressedReload,
        requestTimeout: (_) => _onPressedReload,
        serviceUnavailable: (_) => _onPressedReload,
        noInternetConnection: (_) => _onPressedReload,
        unexpectedError: (_) => _onPressedReload,
      );

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 80),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xff2f3640),
                ),
              ),
              if (onPressed != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                )
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return _child;
  }
}
