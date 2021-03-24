// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:native_app/base/api/exception.dart';
import 'package:native_app/base/constants.dart';
import 'package:native_app/base/preference.dart';

import 'result.dart';

abstract class ToJson {
  Map<String, dynamic> toJson();
}

class ApiClient {
  final _dio = _getDio();
  final _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  Future<ApiResult<Result>> get<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
  }) async {
    return _call(request: _get(path: path), decode: decode);
  }

  Future<ApiResult<Result>> post<Result, Data extends ToJson>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    required Data data,
    bool useFormData = false,
  }) async {
    return _call(
      request: _post(
        path: path,
        data: data.toJson(),
        useFormData: useFormData,
      ),
      decode: decode,
    );
  }

  Future<ApiResult<Result>> put<Result, Data extends ToJson>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    required Data data,
    bool useFormData = false,
  }) async {
    return _call(
      request: _put(
        path: path,
        data: data.toJson(),
        useFormData: useFormData,
      ),
      decode: decode,
    );
  }

  Future<ApiResult<Result>> delete<Result, Data extends ToJson>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
  }) async {
    return _call(request: _delete(path: path), decode: decode);
  }

  Future<ApiResult<T>> _call<T>(
      {required Future<Response<dynamic>> request,
      required T Function(Map<String, dynamic>) decode}) async {
    try {
      final result = await request;
      final data = result.data is Map ? result.data : {};
      return ApiResult.success(decode(data as Map<String, dynamic>));
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
    bool useFormData = false,
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
    bool useFormData = false,
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
      connectTimeout: 5000,
      receiveTimeout: 3000,
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

    final token = await Preference.token.get();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final language = await Preference.language.get();
    if (language != null) {
      headers['Accept-Language'] = language;
    }

    return Options(headers: headers);
  }
}
