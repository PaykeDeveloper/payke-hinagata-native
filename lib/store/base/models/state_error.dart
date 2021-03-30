import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import './error_result.dart';

part 'state_error.freezed.dart';

@freezed
class StateError with _$StateError {
  const factory StateError.sendTimeout() = SendTimeout;

  const factory StateError.requestCancelled() = RequestCancelled;

  const factory StateError.unauthorisedRequest(ErrorResult result) =
      UnauthorisedRequest;

  const factory StateError.badRequest(ErrorResult result) = BadRequest;

  const factory StateError.notFound() = NotFound;

  const factory StateError.requestTimeout() = RequestTimeout;

  const factory StateError.serviceUnavailable() = ServiceUnavailable;

  const factory StateError.noInternetConnection() = NoInternetConnection;

  const factory StateError.unexpectedError() = UnexpectedError;
}

StateError getStateError(Exception exception) {
  if (exception is DioError) {
    switch (exception.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return const StateError.sendTimeout();
      case DioErrorType.cancel:
        return const StateError.requestCancelled();
      case DioErrorType.response:
        final statusCode = exception.response?.statusCode;
        if (statusCode == null) {
          break;
        } else if (statusCode == HttpStatus.unauthorized) {
          final json = exception.response?.data as Map<String, dynamic>?;
          return StateError.unauthorisedRequest(
              ErrorResult.fromJson(json ?? {}));
        } else if (statusCode == HttpStatus.notFound) {
          return const StateError.notFound();
        } else if (400 <= statusCode && statusCode < 500) {
          final json = exception.response?.data as Map<String, dynamic>?;
          return StateError.badRequest(ErrorResult.fromJson(json ?? {}));
        } else if (500 <= statusCode) {
          return const StateError.serviceUnavailable();
        }
        break;
      case DioErrorType.other:
        if (exception.error is SocketException ||
            exception.error is HandshakeException) {
          return const StateError.noInternetConnection();
        }
        break;
    }
  }
  return const StateError.unexpectedError();
}
