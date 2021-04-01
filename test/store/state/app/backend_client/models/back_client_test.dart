import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/login/models/login_input.dart';
import 'package:native_app/store/state/app/login/models/login_output.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';

void main() {
  group('ApiClient Tests', () {
    test('ログイン、データ取得、ログアウトを一通り通す。', () async {
      const data = LoginInput(
        email: 'user01@example.com',
        password: 'payke123',
        packageName: 'web',
        platformType: 'web',
      );
      final client = BackendClient();
      final loginResult = await client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login',
        data: data,
      );
      // result.when(
      //   success: (data) {},
      //   failure: (exception) {},
      // );
      // if (result is Success<LoginOutput>) {
      //   final token = result.data.token.value;
      // }
      if (loginResult is Failure<LoginOutput>) {
        final actual = loginResult.error is BadRequest ||
            loginResult.error is NoInternetConnection ||
            loginResult.error is NotFound;
        expect(actual, true);
        return;
      }

      final token = loginResult.getDataOrNull()?.token;
      client.setToken(token);

      final booksResult = await client.getList(
        decode: (json) => Book.fromJson(json),
        path: 'api/v1/books',
      );
      expect(booksResult is Success<List<Book>>, true);

      final logoutResult = await client.post(
        decode: (json) => json,
        path: 'api/v1/logout',
      );
      expect(logoutResult is Success, true);
    });
  });
}
