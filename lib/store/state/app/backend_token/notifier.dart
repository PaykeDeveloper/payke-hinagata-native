import 'package:native_app/base/preference.dart';
import 'package:native_app/store/base/notifiers/preference.dart';
import 'package:native_app/store/state/app/preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/backend_token.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class BackendTokenState extends _$BackendTokenState
    with PreferenceMixin<BackendToken, String> {
  @override
  FutureOr<BackendToken?> build() async => buildDefault();

  @override
  Preference<String> getPreference() => backendToken;

  @override
  String serialize(BackendToken state) => state.value;

  @override
  BackendToken deserialize(String preference) => BackendToken(preference);
}
