import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@riverpod
class LogoutState extends _$LogoutState {
  @override
  Null build() => null;

  Future logout() async {
    final client = ref.read(backendClientProvider);
    await client.post(
      decode: (json) => null,
      path: '/api/v1/logout',
    );
    final notifier = ref.read(backendTokenStateProvider.notifier);
    await notifier.removeToken();
  }
}
