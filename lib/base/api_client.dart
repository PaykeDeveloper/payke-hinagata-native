import 'package:dio/dio.dart';
import 'package:native_app/base/constants.dart';

class ApiClient {
  ApiClient(String baseUrl) {
    _dio = _getDio(baseUrl);
  }

  late final Dio _dio;
  final _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  String? token;

  String? language;

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

  Future<Response<Result>> patch<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    CancelToken? cancelToken,
  }) async {
    final options = await _getOptions();
    options.headers?['X-HTTP-Method-Override'] = 'PATCH';
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

  static Dio _getDio(String baseUrl) {
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

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (language != null) {
      headers['Accept-Language'] = language;
    }

    return Options(headers: headers);
  }
}
