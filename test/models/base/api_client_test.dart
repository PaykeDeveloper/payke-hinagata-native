import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/base/api/client.dart';
import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/login_output.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LoginOutput Tests', () {
    SharedPreferences.setMockInitialValues({});

    test('Jsonを正しくパース出来る。', () async {
      const data =
          LoginInput(email: 'user01@example.com', password: 'payke123');
      final client = ApiClient();
      final result = await client.post(
        decode: (json) => LoginOutput.fromJson(json),
        path: '/api/v1/login',
        data: data,
      );
      result.when(
        success: (data) {
          print(data);
        },
        failure: (exception) {
          print(exception);
        },
      );
      final foo = result.getOrNull();
      print(foo);
    });
  });
}
