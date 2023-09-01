import 'package:native_app/base/secure_store.dart';
import 'package:native_app/store/base/notifiers/secure_store.dart';
import 'package:native_app/store/state/app/secure_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/backend_token.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class BackendTokenState extends _$BackendTokenState
    with SecureStoreMixin<BackendToken, String> {
  @override
  FutureOr<BackendToken?> build() async => buildDefault();

  @override
  SecureStore<String> getSecureStore() => backendTokenPref;

  @override
  String serialize(BackendToken state) => state.value;

  @override
  BackendToken deserialize(String preference) => BackendToken(preference);
}
