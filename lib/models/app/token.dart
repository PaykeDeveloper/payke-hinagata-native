import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';

part 'token.g.dart';

@freezed
class Token with _$Token {
  const factory Token(String value) = _Token;

  factory Token.fromJson(dynamic value) => Token(value as String);
}
