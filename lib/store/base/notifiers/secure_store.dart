import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/base/secure_store.dart';

abstract class _SecureStoreState<S, P> extends AsyncNotifier<S?> {
  SecureStore<P> getSecureStore();

  S deserialize(P preference);

  P serialize(S state);
}

mixin SecureStoreMixin<S, P> implements _SecureStoreState<S, P> {
  FutureOr<S?> buildDefault() async {
    final value = await getSecureStore().get();
    return value != null ? deserialize(value) : null;
  }

  Future<void> set(S data) async {
    await getSecureStore().set(serialize(data));
    state = AsyncValue.data(data);
  }

  Future<void> remove() async {
    await getSecureStore().remove();
    state = AsyncValue<S?>.data(null);
  }

  Future<bool> containsKey() async => await getSecureStore().containsKey();
}
