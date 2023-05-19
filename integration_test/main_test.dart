import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_app/base/api_client.dart';
import 'package:native_app/main.dart' as app;
import 'package:native_app/store/state/app/preference.dart';
import 'package:native_app/ui/utils.dart';

const _divisionName = 'Division1';
const _projectName = 'Project1';
const _projectNewName = 'NewProject1';

void main() {
  group('Device test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    setUp(() {
      getIt.unregister<ApiClient>();
      getIt.registerFactoryParam<ApiClient, String, void>(
          (url, _) => ApiClientMock(url: url));
    });

    testWidgets("New user", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const ValueKey('email')), 'test@example.com');
      await tester.enterText(
          find.byKey(const ValueKey('password')), 'password');
      await tester.tap(find.text('ログイン'));
      await tester.pumpAndSettle();
      expect(find.text('Divisions'), findsOneWidget);
    });

    testWidgets("Existing user", (tester) async {
      await backendToken.set("test");
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text(_divisionName));
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(find.text('Projects'));
      await tester.pump(const Duration(seconds: 6));
      await tester.tap(find.text(_projectName));
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump(const Duration(seconds: 3));
      await tester.enterText(
          find.byKey(const ValueKey('name')), _projectNewName);
      await tester.ensureVisible(find.text('送信'));
      await tester.tap(find.text('送信'));
      await tester.pump(const Duration(seconds: 3));
      expect(find.textContaining(_projectNewName), findsOneWidget);
    });
  });
}

class ApiClientMock extends ApiClientImpl {
  ApiClientMock({required String url}) : super(url: url) {
    final adapter = DioAdapter(dio: dio);
    _inspect(adapter);
  }
}

void _inspect(DioAdapter adapter) => adapter
  ..onPost(
    '/api/v1/login',
    (server) => server.reply(200, {"token": "test"}),
    data: Matchers.any,
  )
  ..onGet(
    '/api/v1/roles',
    (server) => server.reply(200, [
      {"id": 1, "name": "Administrator", "type": "user", "required": false},
    ]),
  )
  ..onGet(
    '/api/v1/users',
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
    '/api/v1/divisions',
    (server) => server.reply(200, [
      {
        "id": 1,
        "name": _divisionName,
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
  )
  ..onGet(
      '/api/v1/divisions/1/projects',
      (server) => server.reply(200, [
            {
              "id": 1,
              "division_id": 1,
              "slug": "d5095f7e-eb63-40b5-a641-2e672d167384",
              "name": _projectName,
              "description": "ABV",
              "priority": "high",
              "approved": true,
              "start_date": "2021-06-01",
              "finished_at": "2021-06-03T03:09:00.000000Z",
              "difficulty": 1,
              "coefficient": 2.3,
              "productivity": 4.5,
              "lock_version": 17,
              "created_at": "2021-06-02T07:04:03.000000Z",
              "updated_at": "2021-06-04T03:51:17.000000Z",
              "deleted_at": null,
              "cover_url": "https://placehold.jp/150x150.png"
            }
          ]))
  ..onGet(
      '/api/v1/divisions/1/projects/d5095f7e-eb63-40b5-a641-2e672d167384',
      (server) => server.reply(200, {
            "id": 1,
            "division_id": 1,
            "slug": "6b42f759-0de1-45dd-bb1d-e82af6207a55",
            "name": _projectName,
            "description": "",
            "priority": null,
            "approved": false,
            "start_date": null,
            "finished_at": null,
            "difficulty": null,
            "coefficient": null,
            "productivity": null,
            "lock_version": 3,
            "created_at": "2021-06-02T05:05:13.000000Z",
            "updated_at": "2021-07-21T03:59:27.000000Z",
            "deleted_at": null,
            "cover_url": ""
          }))
  ..onPost(
      '/api/v1/divisions/1/projects/d5095f7e-eb63-40b5-a641-2e672d167384',
      (server) => server.reply(200, {
            "id": 1,
            "division_id": 1,
            "slug": "6b42f759-0de1-45dd-bb1d-e82af6207a55",
            "name": _projectNewName,
            "description": "",
            "priority": null,
            "approved": false,
            "start_date": null,
            "finished_at": null,
            "difficulty": null,
            "coefficient": null,
            "productivity": null,
            "lock_version": 3,
            "created_at": "2021-06-02T05:05:13.000000Z",
            "updated_at": "2021-07-21T03:59:27.000000Z",
            "deleted_at": null,
            "cover_url": ""
          }),
      data: Matchers.any);
