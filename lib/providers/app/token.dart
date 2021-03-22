import 'package:flutter/foundation.dart';
import 'package:native_app/models/preference.dart';

class TokenProvider with ChangeNotifier {
  TokenProvider() {
    _load();
  }

  bool _loaded = false;

  bool get loaded => _loaded;

  String? _token;

  String? get token => _token;

  Future _load() async {
    _token = await Preference.token.get();
    _loaded = true;
    notifyListeners();
  }

  Future<bool> set(String token) async {
    final result = Preference.token.set(token);
    _load();
    return result;
  }
}
