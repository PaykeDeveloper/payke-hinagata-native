import 'package:flutter/foundation.dart';
import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/token.dart';

class TokenProvider with ChangeNotifier {
  TokenProvider() {
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

  Future<bool> set(Token token) async {
    final result = Preference.token.set(token.value);
    _load();
    return result;
  }
}
