import 'package:freezed_annotation/freezed_annotation.dart';

part 'backend_token.freezed.dart';
part 'backend_token.g.dart';

@freezed
class BackendToken with _$BackendToken {
  const factory BackendToken(String value) = _BackendToken;

  factory BackendToken.fromJson(dynamic value) => BackendToken(value as String);
}
