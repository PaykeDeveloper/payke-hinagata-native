import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class Preferences {
  static final backendToken = StringPreference('backendToken');
  static final language = StringPreference('language');
}

abstract class _Property<T> {
  _Property(this._key);

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

  Future<bool?> remove() async {
    final pref = await getInstance();
    if (!pref.containsKey(_key)) {
      return null;
    }

    return pref.remove(_key);
  }

  Future<T?> get({T? defaultValue}) async {
    final pref = await getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }
    return getOrThrow(defaultValue: defaultValue);
  }

  Future<T> getOrThrow({T? defaultValue});
}

class BoolPreference extends _Property<bool> {
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

class IntPreference extends _Property<int> {
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

class DoublePreference extends _Property<double> {
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

class StringPreference extends _Property<String> {
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

class StringListPreference extends _Property<List<String>> {
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
