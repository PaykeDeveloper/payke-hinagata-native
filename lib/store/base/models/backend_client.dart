import './json_generator.dart';
import './store_result.dart';

abstract class BackendClient {
  Future<StoreResult<Result>> get<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? queryParameters,
  });

  Future<StoreResult<Result>> getObject<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Map<String, dynamic>? queryParameters,
  });

  Future<StoreResult<List<Result>>> getList<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Map<String, dynamic>? queryParameters,
  });

  Future<StoreResult<Result>> post<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
    bool containNull = true,
  });

  Future<StoreResult<Result>> postObject<Result, Data extends JsonGenerator>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Data? data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  });

  Future<StoreResult<Result>> patch<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
    bool containNull = true,
  });

  Future<StoreResult<Result>> patchObject<Result, Data extends JsonGenerator>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
    Data? data,
    Map<String, dynamic>? queryParameters,
    bool useFormData = false,
  });

  Future<StoreResult<Result>> delete<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? queryParameters,
  });
}
