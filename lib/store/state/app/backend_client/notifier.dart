import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:native_app/store/state/app/locale/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/backend_client.dart';

part 'notifier.g.dart';

@riverpod
BackendClient backendClient(BackendClientRef ref) {
  final client = BackendClient();
  final locale = ref.watch(localeProvider);
  client.setLocale(locale);
  final token = ref.watch(backendTokenProvider).data;
  client.setToken(token);
  return client;
}
