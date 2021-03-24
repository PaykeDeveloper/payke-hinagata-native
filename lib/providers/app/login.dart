import 'package:flutter/foundation.dart';
import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/login_output.dart';
import 'package:native_app/providers/app/api_client.dart';

class LoginProvider with ChangeNotifier {
  LoginProvider(this._apiClientProvider);

  final ApiClientProvider? _apiClientProvider;

  bool _loading = false;

  bool get loading => _loading;

  Future<LoginOutput?> login(LoginInput input) async {
    _loading = true;
    final result = await _apiClientProvider?.client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login',
        data: input);
    _loading = false;
    notifyListeners();
    return result?.getDataOrNull();
  }
}
