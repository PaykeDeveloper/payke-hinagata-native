import 'package:native_app/base/preference.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:state_notifier/state_notifier.dart';

import 'models/token.dart';

class TokenNotifier extends StateNotifier<EntityState<Token?>>
    with LocatorMixin {
  TokenNotifier() : super(const EntityState(null));

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
