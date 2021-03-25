import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/store/state/app/login/models/login_output.dart';
import 'package:native_app/store/state/app/token/models/token.dart';

void main() {
  group('LoginOutput Tests', () {
    test('Jsonを正しくパース出来る。', () {
      const expected = Token('token value');
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
