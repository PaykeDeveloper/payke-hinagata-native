import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/base/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class TestPreference {
  static final boolValue = BoolPreference('boolValue');
  static final intValue = IntPreference('intValue');
  static final doubleValue = DoublePreference('doubleValue');
  static final stringValue = StringPreference('stringValue');
  static final stringListValue = StringListPreference('stringListValue');
}

void main() {
  group('Preference Tests', () {
    test('bool', () async {
      SharedPreferences.setMockInitialValues({});
      final pref = TestPreference.boolValue;
      final startValue = await pref.get();
      expect(startValue, null);

      await pref.set(true);
      final createValue = await pref.get();
      expect(createValue, true);

      await pref.set(false);
      final updateValue = await pref.get();
      expect(updateValue, false);

      await pref.remove();
      final deleteValue = await pref.get();
      expect(deleteValue, null);
    });

    test('int', () async {
      SharedPreferences.setMockInitialValues({});
      final pref = TestPreference.intValue;
      final startValue = await pref.get();
      expect(startValue, null);

      await pref.set(1);
      final createValue = await pref.get();
      expect(createValue, 1);

      await pref.set(3);
      final updateValue = await pref.get();
      expect(updateValue, 3);

      await pref.remove();
      final deleteValue = await pref.get();
      expect(deleteValue, null);
    });

    test('double', () async {
      SharedPreferences.setMockInitialValues({});
      final pref = TestPreference.doubleValue;
      final startValue = await pref.get();
      expect(startValue, null);

      await pref.set(1.1);
      final createValue = await pref.get();
      expect(createValue, 1.1);

      await pref.set(2.11);
      final updateValue = await pref.get();
      expect(updateValue, 2.11);

      await pref.remove();
      final deleteValue = await pref.get();
      expect(deleteValue, null);
    });

    test('string', () async {
      SharedPreferences.setMockInitialValues({});
      final pref = TestPreference.stringValue;
      final startValue = await pref.get();
      expect(startValue, null);

      await pref.set('a');
      final createValue = await pref.get();
      expect(createValue, 'a');

      await pref.set('bc');
      final updateValue = await pref.get();
      expect(updateValue, 'bc');

      await pref.remove();
      final deleteValue = await pref.get();
      expect(deleteValue, null);
    });

    test('List<String>', () async {
      SharedPreferences.setMockInitialValues({});
      final pref = TestPreference.stringListValue;
      final startValue = await pref.get();
      expect(startValue, null);

      await pref.set(['a', 'b']);
      final createValue = await pref.get();
      expect(createValue, ['a', 'b']);

      await pref.set(['ac']);
      final updateValue = await pref.get();
      expect(updateValue, ['ac']);

      await pref.remove();
      final deleteValue = await pref.get();
      expect(deleteValue, null);
    });
  });
}
