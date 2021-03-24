import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_result.dart';

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

StateError getStateError(Exception error) {
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        return const StateError.sendTimeout();
      case DioErrorType.CANCEL:
        return const StateError.requestCancelled();
      case DioErrorType.RESPONSE:
        final statusCode = error.response.statusCode;
        if (statusCode == HttpStatus.unauthorized) {
          final Map<String, dynamic> json =
              error.response.data as Map<String, dynamic>;
          return StateError.unauthorisedRequest(ErrorResult.fromJson(json));
        } else if (statusCode == HttpStatus.notFound) {
          return const StateError.notFound();
        } else if (400 <= statusCode && statusCode < 500) {
          final Map<String, dynamic> json =
              error.response.data as Map<String, dynamic>;
          return StateError.badRequest(ErrorResult.fromJson(json));
        } else if (500 <= statusCode) {
          return const StateError.serviceUnavailable();
        }
        break;
      case DioErrorType.DEFAULT:
        if (error.error is SocketException) {
          return const StateError.noInternetConnection();
        }
        break;
    }
  }
  return const StateError.unexpectedError();
}
