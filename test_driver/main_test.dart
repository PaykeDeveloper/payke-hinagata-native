// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Test App', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('login', () async {
      const email = 'admin@examle.com';
      final emailField = find.byValueKey('email');
      await driver.tap(emailField);
      await driver.enterText(email);
      await driver.waitFor(find.text(email));
      const password = 'payke123';
      final passwordField = find.byValueKey('password');
      await driver.tap(passwordField);
      await driver.enterText(password);
      await driver.waitFor(find.text(password));
      final loginButton = find.text('ログイン');
      await driver.tap(loginButton);
      final result = find.text('Division');
      expect(await driver.getText(result), "0");
    });
  });
}
