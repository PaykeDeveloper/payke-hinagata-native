import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/base/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Api Tests', () {
    SharedPreferences.setMockInitialValues({});

    test('GETリクエストが成功する。', () async {
      final response = await get('/api/v1/status');
      // expect(response.statusCode, 200);
      // expect(response.data, {'is_authenticated': false});
    });

    test('POSTリクエストが成功する。', () async {
      final data = {'email': 'user01@example.com', 'password': 'payke123'};
      final loginResponse = await post('/api/v1/login', data);
      // expect(loginResponse.statusCode, 200);
      //
      // SharedPreferences.setMockInitialValues({
      //   'token': '${loginResponse.data['token']}',
      // });
      // final statusResponse = await post('/api/v1/logout', {});
      // expect(statusResponse.statusCode, 204);
    });
  });
}
