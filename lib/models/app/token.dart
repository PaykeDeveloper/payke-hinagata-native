import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';

@freezed
abstract class Token with _$Token {
  const factory Token(String value) = _Token;
}
