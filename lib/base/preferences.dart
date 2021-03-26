import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class Preferences {
  static final backendToken = StringPreference('backendToken');
  static final language = StringPreference('language');
}

abstract class _Property<T> {
  _Property(this._key);

  final String _key;

  Future<bool> set(T value);

  Future<bool?> remove() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return null;
    }

    return pref.remove(_key);
  }

  Future<T?> get({T? defaultValue});
}

class BoolPreference extends _Property<bool> {
  BoolPreference(String key) : super(key);

  @override
  Future<bool?> get({bool? defaultValue}) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }
    return pref.getBool(_key);
  }

  @override
  Future<bool> set(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setBool(_key, value);
  }
}

class IntPreference extends _Property<int> {
  IntPreference(String key) : super(key);

  @override
  Future<int?> get({int? defaultValue}) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }
    return pref.getInt(_key);
  }

  @override
  Future<bool> set(int value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setInt(_key, value);
  }
}

class DoublePreference extends _Property<double> {
  DoublePreference(String key) : super(key);

  @override
  Future<double?> get({double? defaultValue}) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }
    return pref.getDouble(_key);
  }

  @override
  Future<bool> set(double value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setDouble(_key, value);
  }
}

class StringPreference extends _Property<String> {
  StringPreference(String key) : super(key);

  @override
  Future<String?> get({String? defaultValue}) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }
    return pref.getString(_key);
  }

  @override
  Future<bool> set(String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(_key, value);
  }
}

class StringListPreference extends _Property<List<String>> {
  StringListPreference(String key) : super(key);

  @override
  Future<List<String>?> get({List<String>? defaultValue}) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }
    return pref.getStringList(_key);
  }

  @override
  Future<bool> set(List<String> value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setStringList(_key, value);
  }
}
