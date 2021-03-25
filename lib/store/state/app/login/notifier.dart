import 'package:native_app/store/base/models/state_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:state_notifier/state_notifier.dart';

import 'models/login_input.dart';
import 'models/login_output.dart';

class Login {}

class LoginNotifier extends StateNotifier<StoreState<Login>> with LocatorMixin {
  LoginNotifier() : super(StoreState(Login()));

  Future login(LoginInput input) async {
    state = state.copyWith(status: StateStatus.started);
    final client = read<BackendClient>();
    final result = await client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login',
        data: input);
    if (result is Success<LoginOutput>) {
      state = state.copyWith(status: StateStatus.done, error: null);
      await read<BackendTokenNotifier>().setToken(result.data.token);
    } else if (result is Failure<LoginOutput>) {
      state = state.copyWith(status: StateStatus.failed, error: result.error);
    }
  }
}
