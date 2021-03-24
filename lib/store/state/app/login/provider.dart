import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/state_result.dart';
import 'package:native_app/store/base/providers/api_client.dart';
import 'package:native_app/store/base/providers/token.dart';
import 'package:native_app/store/state/app/login/models/login_input.dart';
import 'package:native_app/store/state/app/login/models/login_output.dart';
import 'package:state_notifier/state_notifier.dart';

class Login {}

class LoginProvider extends StateNotifier<EntityState<Login>>
    with LocatorMixin {
  LoginProvider() : super(EntityState(Login()));

  Future login(LoginInput input) async {
    state = state.copyWith(status: StateStatus.started);
    final provider = read<ApiClientProvider>();
    final result = await provider.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login',
        data: input);
    if (result is Success<LoginOutput>) {
      state = state.copyWith(status: StateStatus.done, error: null);
      await read<TokenProvider>().set(result.data.token);
    } else if (result is Failure<LoginOutput>) {
      state = state.copyWith(status: StateStatus.failed, error: result.error);
    }
    // result.when(
    //   success: (data) {
    //     state = state.copyWith(status: StateStatus.done, error: null);
    //     read<TokenProvider>().set(data.token);
    //   },
    //   failure: (error) {
    //     state = state.copyWith(status: StateStatus.failed, error: error);
    //   },
    // );
  }
}
