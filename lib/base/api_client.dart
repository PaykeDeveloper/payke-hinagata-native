import 'dart:io';

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
    final convertedData = useFormData ? await _toFormData(data) : data;
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
    final convertedData = useFormData ? await _toFormData(data) : data;
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
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
    final dio = Dio(options);
    if (!productMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
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

  Future<FormData> _toFormData(Map<String, dynamic> data) async {
    final convertedData = Map<String, dynamic>.from(data);
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is File) {
        final filename = value.path.split('/').last;
        convertedData[entry.key] =
            await MultipartFile.fromFile(value.path, filename: filename);
      }
    }
    return FormData.fromMap(convertedData);
  }
}
