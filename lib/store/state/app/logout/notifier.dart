import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class Logout {}

class LogoutNotifier extends StateNotifier<StoreState<Logout>>
    with LocatorMixin {
  LogoutNotifier() : super(StoreState(Logout()));

  Future logout() async {
    final client = read<BackendClient>();
    await client.post(
      decode: (json) => null,
      path: 'api/v1/logout',
    );
    final notifier = read<BackendTokenNotifier>();
    await notifier.removeToken();
  }
}
