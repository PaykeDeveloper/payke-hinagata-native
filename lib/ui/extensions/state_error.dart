import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/base/models/state_error.dart';

extension StateErrorExt on StateError {
  String getContextMessage(BuildContext context) {
    final message = getMessage();
    if (message != null) {
      return message;
    }

    return map(
      sendTimeout: (_) {
        return AppLocalizations.of(context)!.sendTimeout;
      },
      requestCancelled: (_) {
        return AppLocalizations.of(context)!.requestCancelled;
      },
      unauthorisedRequest: (_) {
        return AppLocalizations.of(context)!.unauthorisedRequest;
      },
      badRequest: (_) {
        return AppLocalizations.of(context)!.badRequest;
      },
      notFound: (_) {
        return AppLocalizations.of(context)!.notFound;
      },
      requestTimeout: (_) {
        return AppLocalizations.of(context)!.requestTimeout;
      },
      serviceUnavailable: (_) {
        return AppLocalizations.of(context)!.serviceUnavailable;
      },
      noInternetConnection: (_) {
        return AppLocalizations.of(context)!.noInternetConnection;
      },
      unexpectedError: (_) {
        return AppLocalizations.of(context)!.unexpectedError;
      },
    );
  }
}
