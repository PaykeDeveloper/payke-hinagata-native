import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:native_app/base/constants.dart';

abstract class ApiClient {
  Future<Response<Result>> get<Result>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Response<Result>> post<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    required bool containNull,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Response<Result>> patch<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    required bool containNull,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Response<Result>> delete<Result>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
}

class ApiClientImpl extends ApiClient {
  ApiClientImpl({required String url}) {
    dio = _getDio(url);
  }

  late final Dio dio;
  final _cancelToken = CancelToken();

  CancelToken get cancelToken => _cancelToken;

  @override
  Future<Response<Result>> get<Result>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get<Result>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  @override
  Future<Response<Result>> post<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    required bool containNull,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final convertedData = useFormData
        ? await _toFormData(data, containNull: containNull)
        : _toMapData(data, containNull: containNull);
    final response = await dio.post<Result>(
      path,
      data: convertedData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  @override
  Future<Response<Result>> patch<Result>({
    required String path,
    required Map<String, dynamic> data,
    required bool useFormData,
    required bool containNull,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final convertedData = useFormData
        ? await _toFormData(data, containNull: containNull)
        : _toMapData(data, containNull: containNull);
    final response = await dio.patch<Result>(
      path,
      data: convertedData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  @override
  Future<Response<Result>> delete<Result>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.delete<Result>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  static Dio _getDio(String baseUrl) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(minutes: 10),
      receiveTimeout: const Duration(minutes: 10),
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

  Future<FormData> _toFormData(Map<String, dynamic> data,
      {required bool containNull}) async {
    final convertedData = Map<String, dynamic>.from(data);
    for (final entry in data.entries) {
      final value = entry.value;
      if (containNull && value == null) {
        convertedData[entry.key] = '';
      } else if (value is XFile) {
        final filename = value.path.split('/').last;
        convertedData[entry.key] =
            await MultipartFile.fromFile(value.path, filename: filename);
      }
    }
    return FormData.fromMap(convertedData);
  }

  Map<String, dynamic> _toMapData(Map<String, dynamic> data,
      {required bool containNull}) {
    if (containNull) {
      return data;
    }
    final convertedData = Map<String, dynamic>.from(data);
    for (final entry in data.entries) {
      final value = entry.value;
      if (!containNull && value == null) {
        convertedData.remove(entry.key);
      }
    }
    return convertedData;
  }
}
