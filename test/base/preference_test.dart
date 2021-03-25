import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/base/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Preference Tests', () {
    final token = Preference.backendToken;

    test('値が設定できる。', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await token.set('test');
      expect(result, true);
    });

    test('値未設定の場合、デフォルト値が取得できる。', () async {
      SharedPreferences.setMockInitialValues({});
      final beforeSave = await token.get();
      expect(beforeSave, null);
    });

    test('値設定済みの場合、値が取得できる。', () async {
      const expected = 'test';
      SharedPreferences.setMockInitialValues({"backendToken": expected});
      final result = await token.get();
      expect(result, expected);
    });

    test('値を削除できる。', () async {
      SharedPreferences.setMockInitialValues({"backendToken": "test"});
      final result = await token.remove();
      expect(result, true);
    });
  });
}
