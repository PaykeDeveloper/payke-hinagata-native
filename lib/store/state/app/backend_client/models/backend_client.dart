import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:native_app/base/api_client.dart';
import 'package:native_app/base/constants.dart';
import 'package:native_app/base/utils.dart';
import 'package:native_app/store/base/models/json_generator.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/ui/utils.dart';

class BackendClient {
  BackendClient() {
    _client = getIt<ApiClient>(param1: backendBaseUrl);
  }

  late final ApiClient _client;

  bool get authenticated => _client.token != null;

  void setToken(BackendToken? token) {
    _client.token = token?.value;
  }

  void setLocale(Locale? locale) {
    _client.language = locale?.toLanguageTag();
  }

  Future<StoreResult<Result>> get<Result>({
    required Result Function(dynamic) decode,
    required String path,
  }) async {
    return _call(request: _client.get(path: path), decode: decode);
  }

  Future<StoreResult<Result>> getObject<Result>({
    required Result Function(Map<String, dynamic>) decode,
    required String path,
  }) async {
    return get(
      decode: (json) => decode(json as Map<String, dynamic>),
      path: path,
    );
  }

  Future<StoreResult<List<Result>>> getList<Result>({
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

  Future<StoreResult<Result>> post<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    bool useFormData = false,
    bool containNull = true,
  }) async {
    return _call(
      request: _client.post(
        path: path,
        data: data ?? {},
        useFormData: useFormData,
        containNull: containNull,
      ),
      decode: decode,
    );
  }

  Future<StoreResult<Result>> postObject<Result, Data extends JsonGenerator>({
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

  Future<StoreResult<Result>> patch<Result>({
    required Result Function(dynamic) decode,
    required String path,
    Map<String, dynamic>? data,
    bool useFormData = false,
    bool containNull = true,
  }) async {
    return _call(
      request: _client.patch(
        path: path,
        data: data ?? {},
        useFormData: useFormData,
        containNull: containNull,
      ),
      decode: decode,
    );
  }

  Future<StoreResult<Result>> patchObject<Result, Data extends JsonGenerator>({
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

  Future<StoreResult<Result>> delete<Result>({
    required Result Function(dynamic) decode,
    required String path,
  }) async {
    return _call(request: _client.delete(path: path), decode: decode);
  }

  Future<StoreResult<T>> _call<T>(
      {required Future<Response<dynamic>> request,
      required T Function(dynamic) decode}) async {
    try {
      final data = await request.then((result) => result.data);
      return StoreResult.success(decode(data));
    } catch (error, stackTrace) {
      if (error is Exception) {
        logger.w('An exception occurred!', error, stackTrace);
        return StoreResult.failure(getStateError(error));
      } else {
        logger.e('An unexpected error occurred!', error, stackTrace);
        return const StoreResult.failure(StoreError.unexpectedError());
      }
    }
  }
}
