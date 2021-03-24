import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/base/api/error_result.dart';

part 'exception.freezed.dart';

@freezed
abstract class ApiException with _$ApiException {
  const factory ApiException.sendTimeout() = SendTimeout;

  const factory ApiException.requestCancelled() = RequestCancelled;

  const factory ApiException.unauthorisedRequest() = UnauthorisedRequest;

  const factory ApiException.badRequest(ErrorResult result) = BadRequest;

  const factory ApiException.notFound() = NotFound;

  const factory ApiException.requestTimeout() = RequestTimeout;

  const factory ApiException.serviceUnavailable() = ServiceUnavailable;

  const factory ApiException.noInternetConnection() = NoInternetConnection;

  const factory ApiException.unexpectedError() = UnexpectedError;
}

ApiException getApiError(Exception error) {
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        return const ApiException.sendTimeout();
      case DioErrorType.CANCEL:
        return const ApiException.requestCancelled();
      case DioErrorType.RESPONSE:
        final statusCode = error.response.statusCode;
        if (404 == statusCode) {
          return const ApiException.notFound();
        } else if (400 <= statusCode && statusCode < 500) {
          final Map<String, dynamic> data = error.response.data is Map
              ? error.response.data as Map<String, dynamic>
              : {};
          return ApiException.badRequest(ErrorResult.fromJson(data));
        } else if (500 <= statusCode) {
          return const ApiException.serviceUnavailable();
        }
        break;
      case DioErrorType.DEFAULT:
        if (error.error is SocketException) {
          return const ApiException.noInternetConnection();
        }
        break;
    }
  }
  return const ApiException.unexpectedError();
}
