import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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

  const factory StateError.notFound(ErrorResult result) = NotFound;

  const factory StateError.requestTimeout() = RequestTimeout;

  const factory StateError.serviceUnavailable(ErrorResult result) =
      ServiceUnavailable;

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
        final data = exception.response?.data;
        final json = data is Map<String, dynamic> ? data : <String, dynamic>{};
        if (statusCode == null) {
          break;
        } else if (statusCode == HttpStatus.unauthorized) {
          return StateError.unauthorisedRequest(ErrorResult.fromJson(json));
        } else if (statusCode == HttpStatus.notFound) {
          return StateError.notFound(ErrorResult.fromJson(json));
        } else if (400 <= statusCode && statusCode < 500) {
          return StateError.badRequest(ErrorResult.fromJson(json));
        } else if (500 <= statusCode) {
          return StateError.serviceUnavailable(ErrorResult.fromJson(json));
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

extension StateErrorExt on StateError {
  String? getMessage() {
    final message = map(
      sendTimeout: (error) => null,
      requestCancelled: (error) => null,
      unauthorisedRequest: (error) => error.result.message,
      badRequest: (error) => error.result.message,
      notFound: (error) => error.result.message,
      requestTimeout: (error) => null,
      serviceUnavailable: (error) => error.result.message,
      noInternetConnection: (error) => null,
      unexpectedError: (error) => null,
    );
    return message?.isNotEmpty == true ? message : null;
  }
}
