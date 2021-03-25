// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:native_app/base/api_client.dart';
import 'package:native_app/base/constants.dart';
import 'package:native_app/store/base/models/serializable.dart';
import 'package:native_app/store/base/models/state_error.dart';
import 'package:native_app/store/base/models/state_result.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/store/state/app/language/models/language.dart';

class BackendClient {
  final _client = ApiClient(backendBaseUrl);

  bool get authenticated => _client.token != null;

  void setToken(BackendToken? token) {
    _client.token = token?.value;
  }

  void setLanguage(Language? language) {
    _client.language = language?.iso639_1;
  }

  Future<StateResult<Result>> get<Result>({
    required Result Function(dynamic) decode,
    required String path,
  }) async {
    return _call(request: _client.get(path: path), decode: decode);
  }

  Future<StateResult<Result>> getObject<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
  }) async {
    return get(
      decode: (json) => decode(json as Map<String, dynamic>),
      path: path,
    );
  }

  Future<StateResult<List<Result>>> getList<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
  }) async {
    return get(
      decode: (list) => (list as List<dynamic>)
          .map((json) => decode(json as Map<String, dynamic>))
          .toList(),
      path: path,
    );
  }

  Future<StateResult<Result>> post<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    bool useFormData = false,
  }) async {
    return _call(
      request: _client.post(
        path: path,
        data: data ?? {},
        useFormData: useFormData,
      ),
      decode: decode,
    );
  }

  Future<StateResult<Result>> postObject<Result, Data extends Serializable>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Data? data,
    bool useFormData = false,
  }) async {
    return post(
      decode: (json) => decode(json as Map<String, dynamic>),
      path: path,
      data: data?.toJson(),
      useFormData: useFormData,
    );
  }

  Future<StateResult<Result>> patch<Result, Data extends Serializable>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    bool useFormData = false,
  }) async {
    return _call(
      request: _client.patch(
        path: path,
        data: data ?? {},
        useFormData: useFormData,
      ),
      decode: decode,
    );
  }

  Future<StateResult<Result>> patchObject<Result, Data extends Serializable>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Data? data,
    bool useFormData = false,
  }) async {
    return patch(
      decode: (json) => decode(json as Map<String, dynamic>),
      path: path,
      data: data?.toJson(),
      useFormData: useFormData,
    );
  }

  Future<StateResult<Result>> delete<Result>({
    required Result Function(dynamic) decode,
    required String path,
  }) async {
    return _call(request: _client.delete(path: path), decode: decode);
  }

  Future<StateResult<T>> _call<T>(
      {required Future<Response<dynamic>> request,
      required T Function(dynamic) decode}) async {
    try {
      final data = await request.then((result) => result.data);
      return StateResult.success(decode(data));
    } on Exception catch (error) {
      return StateResult.failure(getStateError(error));
    }
  }
}
