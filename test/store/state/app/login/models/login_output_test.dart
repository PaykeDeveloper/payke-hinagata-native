import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/store/state/app/login/models/login_output.dart';

void main() {
  group('LoginOutput Tests', () {
    test('Jsonを正しくパース出来る。', () {
      const expected = BackendToken('token value');
      final jsonString = '''
      {
        "token": "${expected.value}"
      }
      ''';

      final output =
          LoginOutput.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      expect(output.token, expected);
    });
  });
}
