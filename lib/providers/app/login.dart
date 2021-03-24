import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/login_output.dart';
import 'package:native_app/providers/app/api_client.dart';
import 'package:state_notifier/state_notifier.dart';

class LoginProvider extends StateNotifier<bool> with LocatorMixin {
  LoginProvider() : super(false);

  Future<LoginOutput?> login(LoginInput input) async {
    state = true;
    final client = read<ApiClientProvider>().state;
    final result = await client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login',
        data: input);
    state = false;
    return result.getDataOrNull();
  }
}
