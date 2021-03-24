import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/base/api/client.dart';
import 'package:native_app/base/api/exception.dart';
import 'package:native_app/base/api/result.dart';
import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/models/app/login_output.dart';
import 'package:native_app/models/domain/sample/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ApiClient Tests', () {
    test('ログイン、データ取得、ログアウトを一通り通す。', () async {
      SharedPreferences.setMockInitialValues({});
      const data =
          LoginInput(email: 'user01@example.com', password: 'payke123');
      final client = ApiClient();
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
        final actual = loginResult.exception is BadRequest ||
            loginResult.exception is NoInternetConnection;
        expect(actual, true);
        return;
      }

      final token = loginResult.getDataOrNull()?.token.value ?? '';
      SharedPreferences.setMockInitialValues({'token': token});

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
