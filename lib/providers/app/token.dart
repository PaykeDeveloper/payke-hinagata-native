import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/provider_state.dart';
import 'package:native_app/models/app/token.dart';
import 'package:state_notifier/state_notifier.dart';

class TokenProvider extends StateNotifier<ProviderState<Token?>> {
  TokenProvider() : super(const ProviderState(null)) {
    state = state.copyWith(status: StateStatus.started);
    _fetch();
  }

  Token? get token => state.data;

  Future _fetch() async {
    final value = await Preference.token.get();
    final token = value != null ? Token(value) : null;
    state = state.copyWith(data: token, status: StateStatus.done);
  }

  Future<bool> set(Token token) async {
    final result = await Preference.token.set(token.value);
    _fetch();
    return result;
  }
}
