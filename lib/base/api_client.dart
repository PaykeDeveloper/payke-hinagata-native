// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:native_app/base/constants.dart';

class ApiClient {
  final _dio = _getDio();
  final _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  String? _token;

  String? get token => _token;

  // ignore: avoid_setters_without_getters
  set token(String? token) {
    _token = token;
  }

  String? _language;

  // ignore: avoid_setters_without_getters
  set language(String? language) {
    _language = language;
  }

  Future<Response<Result>> get<Result>({
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

  Future<Response<Result>> post<Result>({
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

  Future<Response<Result>> put<Result>({
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

  Future<Response<Result>> delete<Result>({
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
      headers['Authorization'] = 'Bearer $token';
    }

    final language = _language;
    if (language != null) {
      headers['Accept-Language'] = language;
    }

    return Options(headers: headers);
  }
}
