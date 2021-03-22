import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/models/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Preference Tests', () {
    final token = Preference.token;

    test('値が設定できる。', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await token.setValue('test');
      expect(result, true);
    });

    test('値未設定の場合、デフォルト値が取得できる。', () async {
      SharedPreferences.setMockInitialValues({});
      final beforeSave = await token.getValue();
      expect(beforeSave, null);
    });

    test('値設定済みの場合、値が取得できる。', () async {
      const expected = 'test';
      SharedPreferences.setMockInitialValues({"token": expected});
      final result = await token.getValue();
      expect(result, expected);
    });

    test('値を削除できる。', () async {
      SharedPreferences.setMockInitialValues({"token": "test"});
      final result = await token.remove();
      expect(result, true);
    });
  });
}
