import 'package:flutter/foundation.dart';
import 'package:native_app/base/api.dart';
import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/token.dart';
import 'package:native_app/providers/app/token.dart';

class LoginProvider with ChangeNotifier {
  LoginProvider(this._authProvider);

  final TokenProvider? _authProvider;

  bool _loading = false;

  bool get loading => _loading;

  Future login(LoginInput input) async {
    _loading = true;
    final response = await post('/api/v1/login', input.toJson());
    final value = response.data['token'] as String;
    await _authProvider?.set(Token(value));
    _loading = false;
    notifyListeners();
  }
}
