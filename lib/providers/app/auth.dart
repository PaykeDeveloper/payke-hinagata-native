import 'package:flutter/foundation.dart';
import 'package:native_app/base/api.dart';
import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/token.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    _load();
  }

  bool _loaded = false;

  bool get loaded => _loaded;

  Token? _token;

  Token? get token => _token;

  Future _load() async {
    final value = await Preference.token.get();
    _token = value != null ? Token(value) : null;
    _loaded = true;
    notifyListeners();
  }

  Future<bool> login(LoginInput input) async {
    final response = await post('/api/v1/login', input.toJson());
    final value = response.data['token'] as String;
    final result = Preference.token.set(value);
    _load();
    return result;
  }
}
