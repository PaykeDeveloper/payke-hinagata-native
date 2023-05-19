import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/backend_client.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
BackendClient backendClient(BackendClientRef ref) {
  final client = BackendClient();
  final locale = ref.watch(localeStateProvider);
  client.setLocale(locale);
  final token =
      ref.watch(backendTokenStateProvider.select((state) => state.value));
  client.setToken(token);
  return client;
}
