// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:native_app/base/api/exception.dart';
import 'package:native_app/base/constants.dart';
import 'package:native_app/models/app/language.dart';
import 'package:native_app/models/app/token.dart';

import 'result.dart';

abstract class ToJson {
  Map<String, dynamic> toJson();
}

class ApiClient {
  final _dio = _getDio();
  final _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  Token? _token;

  // ignore: avoid_setters_without_getters
  set token(Token? token) {
    _token = token;
  }

  Language? _language;

  // ignore: avoid_setters_without_getters
  set language(Language? language) {
    _language = language;
  }

  Future<ApiResult<Result>> get<Result>({
    required Result Function(dynamic) decode,
    required String path,
  }) async {
    return _call(request: _get(path: path), decode: decode);
  }

  Future<ApiResult<Result>> getObject<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
  }) async {
    return get(
      decode: (json) => decode(json as Map<String, dynamic>),
      path: path,
    );
  }

  Future<ApiResult<List<Result>>> getList<Result>({
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

  Future<ApiResult<Result>> post<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    bool useFormData = false,
  }) async {
    return _call(
      request: _post(
        path: path,
        data: data ?? {},
        useFormData: useFormData,
      ),
      decode: decode,
    );
  }

  Future<ApiResult<Result>> postObject<Result, Data extends ToJson>({
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

  Future<ApiResult<Result>> put<Result, Data extends ToJson>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    bool useFormData = false,
  }) async {
    return _call(
      request: _put(
        path: path,
        data: data ?? {},
        useFormData: useFormData,
      ),
      decode: decode,
    );
  }

  Future<ApiResult<Result>> putObject<Result, Data extends ToJson>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Data? data,
    bool useFormData = false,
  }) async {
    return put(
      decode: (json) => decode(json as Map<String, dynamic>),
      path: path,
      data: data?.toJson(),
      useFormData: useFormData,
    );
  }

  Future<ApiResult<Result>> delete<Result>({
    required Result Function(dynamic) decode,
    required String path,
  }) async {
    return _call(request: _delete(path: path), decode: decode);
  }

  Future<ApiResult<T>> _call<T>(
      {required Future<Response<dynamic>> request,
      required T Function(dynamic) decode}) async {
    try {
      final data = await request.then((result) => result.data);
      return ApiResult.success(decode(data));
    } on Exception catch (error) {
      return ApiResult.failure(getApiError(error));
    }
  }

  Future<Response<Result>> _get<Result>({
    required String path,
    CancelToken? cancelToken,
  }) async {
    final options = await _getOptions();
    final response = await _dio.get<Result>(
      path,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  Future<Response<Result>> _post<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    CancelToken? cancelToken,
  }) async {
    final options = await _getOptions();
    final convertedData = useFormData ? FormData.fromMap(data) : data;
    final response = await _dio.post<Result>(
      path,
      data: convertedData,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  Future<Response<Result>> _put<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    CancelToken? cancelToken,
  }) async {
    final options = await _getOptions();
    options.headers['X-HTTP-Method-Override'] = 'PATCH';
    final convertedData = useFormData ? FormData.fromMap(data) : data;
    final response = await _dio.post<Result>(
      path,
      data: convertedData,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  Future<Response<Result>> _delete<Result>({
    required String path,
    CancelToken? cancelToken,
  }) async {
    final options = await _getOptions();
    final response = await _dio.delete<Result>(
      path,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  static Dio _getDio() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
    );
    final dio = Dio(options);
    if (!productMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }
    return dio;
  }

  Future<Options> _getOptions() async {
    final Map<String, dynamic> headers = {
      'Accept': 'application/json',
    };

    final token = _token;
    if (token != null) {
      headers['Authorization'] = 'Bearer ${token.value}';
    }

    final language = _language;
    if (language != null) {
      headers['Accept-Language'] = language.iso639_1;
    }

    return Options(headers: headers);
  }
}
