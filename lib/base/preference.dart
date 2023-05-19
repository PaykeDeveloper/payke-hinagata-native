import 'package:shared_preferences/shared_preferences.dart';

abstract class Preference<T> {
  Preference(this._key);

  final String _key;
  SharedPreferences? _pref;

  Future<SharedPreferences> getInstance() async {
    final oldPref = _pref;
    if (oldPref != null) {
      return oldPref;
    }
    final newPref = await SharedPreferences.getInstance();
    _pref = newPref;
    return newPref;
  }

  Future<bool> set(T value);

  Future<bool> containsKey() async {
    final pref = await getInstance();
    return pref.containsKey(_key);
  }

  Future<bool?> remove() async {
    if (!await containsKey()) {
      return null;
    }

    return removeOrThrow();
  }

  Future<bool> removeOrThrow() async {
    final pref = await getInstance();
    return pref.remove(_key);
  }

  Future<T?> get({T? defaultValue}) async {
    if (!await containsKey()) {
      return defaultValue;
    }
    return getOrThrow(defaultValue: defaultValue);
  }

  Future<T> getOrThrow({T? defaultValue});
}

class BoolPreference extends Preference<bool> {
  BoolPreference(String key) : super(key);

  @override
  Future<bool> set(bool value) async {
    final pref = await getInstance();
    return pref.setBool(_key, value);
  }

  @override
  Future<bool> getOrThrow({bool? defaultValue}) async {
    final pref = await getInstance();
    return pref.getBool(_key)!;
  }
}

class IntPreference extends Preference<int> {
  IntPreference(String key) : super(key);

  @override
  Future<bool> set(int value) async {
    final pref = await getInstance();
    return pref.setInt(_key, value);
  }

  @override
  Future<int> getOrThrow({int? defaultValue}) async {
    final pref = await getInstance();
    return pref.getInt(_key)!;
  }
}

class DoublePreference extends Preference<double> {
  DoublePreference(String key) : super(key);

  @override
  Future<bool> set(double value) async {
    final pref = await getInstance();
    return pref.setDouble(_key, value);
  }

  @override
  Future<double> getOrThrow({double? defaultValue}) async {
    final pref = await getInstance();
    return pref.getDouble(_key)!;
  }
}

class StringPreference extends Preference<String> {
  StringPreference(String key) : super(key);

  @override
  Future<bool> set(String value) async {
    final pref = await getInstance();
    return pref.setString(_key, value);
  }

  @override
  Future<String> getOrThrow({String? defaultValue}) async {
    final pref = await getInstance();
    return pref.getString(_key)!;
  }
}

class StringListPreference extends Preference<List<String>> {
  StringListPreference(String key) : super(key);

  @override
  Future<bool> set(List<String> value) async {
    final pref = await getInstance();
    return pref.setStringList(_key, value);
  }

  @override
  Future<List<String>> getOrThrow({List<String>? defaultValue}) async {
    final pref = await getInstance();
    return pref.getStringList(_key)!;
  }
}
