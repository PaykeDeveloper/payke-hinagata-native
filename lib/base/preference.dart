import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class Preference {
  static final backendToken = _PreferenceProperty<String>('backendToken');
  static final language = _PreferenceProperty<String>('language');
}

class _PreferenceProperty<T> {
  _PreferenceProperty(this._key);

  final String _key;

  Future<bool> set(T value) async {
    final pref = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        if (value is bool) {
          return pref.setBool(_key, value);
        }
        break;
      case int:
        if (value is int) {
          return pref.setInt(_key, value);
        }
        break;
      case double:
        if (value is double) {
          return pref.setDouble(_key, value);
        }
        break;
      case String:
        if (value is String) {
          return pref.setString(_key, value);
        }
        break;
      case List:
        if (value is List<String>) {
          return pref.setStringList(_key, value);
        }
        break;
    }
    throw AssertionError();
  }

  Future<bool?> remove() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return null;
    }

    return pref.remove(_key);
  }

  Future<T?> get({T? defaultValue}) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(_key)) {
      return defaultValue;
    }

    switch (T) {
      case bool:
        return pref.getBool(_key) as T?;
      case int:
        return pref.getInt(_key) as T?;
      case double:
        return pref.getDouble(_key) as T?;
      case String:
        return pref.getString(_key) as T?;
      case List:
        return pref.getStringList(_key) as T?;
    }
    throw AssertionError();
  }
}
