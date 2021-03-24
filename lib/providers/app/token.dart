import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/token.dart';
import 'package:state_notifier/state_notifier.dart';

class TokenProvider extends StateNotifier<Token?> {
  TokenProvider() : super(null) {
    _fetch();
  }

  Token? get token => state;

  Future<bool> set(Token token) async {
    final result = await Preference.token.set(token.value);
    _fetch();
    return result;
  }

  Future<bool?> remove() async {
    return Preference.token.remove();
  }

  Future _fetch() async {
    final value = await Preference.token.get();
    state = value != null ? Token(value) : null;
  }
}
