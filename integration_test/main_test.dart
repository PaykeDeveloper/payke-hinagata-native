import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("failing test example", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    const email = 'admin@example.com';
    final emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, email);
    const password = 'payke123';
    final passwordField = find.byKey(const Key('password'));
    await tester.enterText(passwordField, password);
    final loginButton = find.text('ログイン');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 20));
    expect(find.byKey(const Key('test')), findsOneWidget);
  });
}
