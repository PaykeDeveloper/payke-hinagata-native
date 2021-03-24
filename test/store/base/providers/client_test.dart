import 'package:flutter_test/flutter_test.dart';
import 'package:native_app/store/base/models/state_result.dart';
import 'package:native_app/store/base/models/state_error.dart';
import 'package:native_app/store/base/providers/api_client.dart';
import 'package:native_app/store/state/app/login/models/login_input.dart';
import 'package:native_app/store/state/app/login/models/login_output.dart';
import 'package:native_app/store/state/domain/sample/models/book.dart';

void main() {
  group('ApiClient Tests', () {
    test('ログイン、データ取得、ログアウトを一通り通す。', () async {
      const data =
          LoginInput(email: 'user01@example.com', password: 'payke123');
      final provider = ApiClientProvider();
      final loginResult = await provider.postObject(
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
            loginResult.error is NoInternetConnection;
        expect(actual, true);
        return;
      }

      final token = loginResult.getDataOrNull()?.token;
      // ignore: invalid_use_of_protected_member
      provider.state.token = token?.value;

      final booksResult = await provider.getList(
        decode: (json) => Book.fromJson(json),
        path: 'api/v1/books',
      );
      expect(booksResult is Success<List<Book>>, true);

      final logoutResult = await provider.post(
        decode: (json) => json,
        path: 'api/v1/logout',
      );
      expect(logoutResult is Success, true);
    });
  });
}
