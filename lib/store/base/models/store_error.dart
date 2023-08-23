import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import './error_result.dart';

part 'store_error.freezed.dart';

@freezed
sealed class StoreError with _$StoreError {
  const factory StoreError.sendTimeout() = SendTimeout;

  const factory StoreError.requestCancelled() = RequestCancelled;

  const factory StoreError.unauthorisedRequest(ErrorResult? result) =
      UnauthorisedRequest;

  const factory StoreError.badRequest(ErrorResult result) = BadRequest;

  const factory StoreError.notFound(ErrorResult result) = NotFound;

  const factory StoreError.requestTimeout() = RequestTimeout;

  const factory StoreError.serviceUnavailable(ErrorResult? result) =
      ServiceUnavailable;

  const factory StoreError.noInternetConnection() = NoInternetConnection;

  const factory StoreError.unexpectedError() = UnexpectedError;
}

StoreError getStateError(Exception exception) {
  if (exception is DioException) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const StoreError.sendTimeout();
      case DioExceptionType.cancel:
        return const StoreError.requestCancelled();
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == null) {
          break;
        }

        final data = exception.response?.data;
        final json = data is Map<String, dynamic> ? data : <String, dynamic>{};
        if (statusCode == HttpStatus.unauthorized) {
          return StoreError.unauthorisedRequest(ErrorResult.fromJson(json));
        } else if (statusCode == HttpStatus.notFound) {
          return StoreError.notFound(ErrorResult.fromJson(json));
        } else if (400 <= statusCode && statusCode < 500) {
          return StoreError.badRequest(ErrorResult.fromJson(json));
        } else if (500 <= statusCode) {
          return StoreError.serviceUnavailable(ErrorResult.fromJson(json));
        }
        break;
      case DioExceptionType.connectionError:
        return const StoreError.noInternetConnection();
      case DioExceptionType.badCertificate:
        return const StoreError.unauthorisedRequest(null);
      case DioExceptionType.unknown:
        if (exception.error is SocketException) {
          return const StoreError.serviceUnavailable(null);
        }
        break;
    }
  }
  return const StoreError.unexpectedError();
}

extension StateErrorExt on StoreError {
  String? getMessage() {
    final message = map(
      sendTimeout: (error) => null,
      requestCancelled: (error) => null,
      unauthorisedRequest: (error) => error.result?.message,
      badRequest: (error) => error.result.message,
      notFound: (error) => error.result.message,
      requestTimeout: (error) => null,
      serviceUnavailable: (error) => error.result?.message,
      noInternetConnection: (error) => null,
      unexpectedError: (error) => null,
    );
    return message?.isNotEmpty == true ? message : null;
  }
}
