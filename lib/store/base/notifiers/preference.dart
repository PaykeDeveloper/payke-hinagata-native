import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/base/preference.dart';

abstract class _PreferenceState<S, P> extends AsyncNotifier<S?> {
  Preference<P> getPreference();

  S deserialize(P preference);

  P serialize(S state);
}

mixin PreferenceMixin<S, P> implements _PreferenceState<S, P> {
  FutureOr<S?> buildDefault() async {
    final value = await getPreference().get();
    return value != null ? deserialize(value) : null;
  }

  Future<bool> set(S data) async {
    final result = await getPreference().set(serialize(data));
    state = AsyncValue.data(data);
    return result;
  }

  Future<bool?> remove() async {
    final result = await getPreference().remove();
    state = const AsyncValue.data(null);
    return result;
  }
}
