import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _secureStore = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

abstract class SecureStore<T> {
  SecureStore(this._key);

  final _store = _secureStore;
  final String _key;

  Future<void> set(T value);

  Future<bool> containsKey() async => _store.containsKey(key: _key);

  Future<void> remove() async {
    if (await containsKey()) {
      return;
    }

    return removeOrThrow();
  }

  Future<void> removeOrThrow() async => _store.delete(key: _key);

  Future<T?> get({T? defaultValue}) async {
    if (!await containsKey()) {
      return defaultValue;
    }
    return getOrThrow(defaultValue: defaultValue);
  }

  Future<T> getOrThrow({T? defaultValue});
}

class StringSecureStore extends SecureStore<String> {
  StringSecureStore(super.key);

  @override
  Future<String> getOrThrow({String? defaultValue}) async =>
      (await _store.read(key: _key))!;

  @override
  Future<void> set(String value) => _store.write(key: _key, value: value);
}
