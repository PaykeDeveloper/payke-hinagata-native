import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/login_output.dart';
import 'package:native_app/models/app/provider_state.dart';
import 'package:native_app/providers/app/api_client.dart';
import 'package:state_notifier/state_notifier.dart';

class Login {}

class LoginProvider extends StateNotifier<ProviderState<Login>>
    with LocatorMixin {
  LoginProvider() : super(ProviderState(Login()));

  Future<LoginOutput?> login(LoginInput input) async {
    state = state.copyWith(status: StateStatus.started);
    final client = read<ApiClientProvider>().state;
    final result = await client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login',
        data: input);
    state = state.copyWith(status: StateStatus.done);
    return result.getDataOrNull();
  }
}
