import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class Logout {}

typedef LogoutState = StoreState<Logout>;

class LogoutNotifier extends StateNotifier<LogoutState> with LocatorMixin {
  LogoutNotifier(this._ref) : super(StoreState(Logout()));

  final Ref _ref;

  Future logout() async {
    final client = _ref.read(backendClientProvider);
    await client.post(
      decode: (json) => null,
      path: '/api/v1/logout',
    );
    final notifier = _ref.read(backendTokenProvider.notifier);
    await notifier.removeToken();
  }
}

final logoutProvider = StateNotifierProvider<LogoutNotifier, LogoutState>(
    (ref) => LogoutNotifier(ref));
