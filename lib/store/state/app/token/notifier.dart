import 'package:native_app/base/preference.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:state_notifier/state_notifier.dart';

import 'models/token.dart';

class TokenNotifier extends StateNotifier<StoreState<Token?>>
    with LocatorMixin {
  TokenNotifier() : super(const StoreState(null));

  @override
  void initState() {
    super.initState();
    state = state.copyWith(status: StateStatus.started);
    _fetch();
  }

  Future _fetch() async {
    final value = await Preference.token.get();
    final token = value != null ? Token(value) : null;
    state = state.copyWith(data: token, status: StateStatus.done);
  }

  Future<bool> set(Token token) async {
    final result = await Preference.token.set(token.value);
    state = state.copyWith(data: token, status: StateStatus.done);
    return result;
  }
}
