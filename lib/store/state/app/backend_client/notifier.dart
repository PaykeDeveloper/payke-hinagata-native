import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

import './models/backend_client.dart';

class BackendClientNotifier extends StateNotifier<BackendClient>
    with LocatorMixin {
  BackendClientNotifier(Ref ref) : super(BackendClient()) {
    final locale = ref.watch(localeProvider);
    state.setLocale(locale);
    final token = ref.watch(backendTokenProvider).data;
    state.setToken(token);
  }
}

final backendClientProvider =
    StateNotifierProvider<BackendClientNotifier, BackendClient>(
        (ref) => BackendClientNotifier(ref));
