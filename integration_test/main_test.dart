import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_app/base/preferences.dart';
import 'package:native_app/main.dart' as app;

void main() {
  group('Device test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("login", (tester) async {
      app.run(backendInspector: (dio) {
        final adapter = DioAdapter(dio: dio);
        inspect(adapter);
        return dio;
      });
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email')), 'admin@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'payke123');
      await tester.tap(find.text('ログイン'));
      await tester.pumpAndSettle();
      expect(find.text('Divisions'), findsOneWidget);
    });

    testWidgets("After login", (tester) async {
      await Preferences.backendToken.set("test");
      app.run(backendInspector: (dio) {
        final adapter = DioAdapter(dio: dio);
        inspect(adapter);
        return dio;
      });
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test1'));
      await Future.delayed(const Duration(seconds: 3));
      expect(find.text('Home'), findsWidgets);
    });
  });
}

void inspect(DioAdapter adapter) => adapter
  ..onPost(
    'api/v1/login',
    (server) => server.reply(200, {"token": "test"}),
    data: Matchers.any,
  )
  ..onGet(
    'api/v1/roles/',
    (server) => server.reply(200, [
      {"id": 1, "name": "Administrator", "type": "user", "required": false},
    ]),
  )
  ..onGet(
    'api/v1/users/',
    (server) => server.reply(200, [
      {
        "id": 1,
        "name": "admin",
        "email": "admin@example.com",
        "email_verified_at": "2021-05-26T07:51:06.000000Z",
        "locale": null,
        "created_at": "2021-05-26T07:51:06.000000Z",
        "updated_at": "2021-05-26T07:51:06.000000Z",
        "permission_names": ["user_viewAll"],
        "role_names": ["Administrator"]
      }
    ]),
  )
  ..onGet(
    'api/v1/divisions/',
    (server) => server.reply(200, [
      {
        "id": 1,
        "name": "Test1",
        "created_at": "2021-05-26T07:52:11.000000Z",
        "updated_at": "2021-07-21T06:28:05.000000Z",
        "request_member_id": 1,
        "permission_names": [
          "division_viewOwn",
          "division_createOwn",
          "division_updateOwn",
          "division_deleteOwn",
          "member_viewAll",
          "member_createAll",
          "member_updateAll",
          "member_deleteAll",
          "project_viewAll",
          "project_createAll",
          "project_updateAll",
          "project_deleteAll"
        ]
      }
    ]),
  );
