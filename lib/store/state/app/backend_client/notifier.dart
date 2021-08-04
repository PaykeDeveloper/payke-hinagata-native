import 'dart:ui';

import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

import './models/backend_client.dart';

class BackendClientNotifier extends StateNotifier<BackendClient>
    with LocatorMixin {
  BackendClientNotifier() : super(BackendClient());

  @override
  void update(Locator watch) {
    super.update(watch);
    final locale = watch<Locale?>();
    state.setLocale(locale);
    final token = watch<BackendTokenState>().data;
    state.setToken(token);
  }
}
