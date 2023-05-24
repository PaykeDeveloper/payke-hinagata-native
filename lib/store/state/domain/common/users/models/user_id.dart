import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_id.freezed.dart';
part 'user_id.g.dart';

@freezed
class UserId with _$UserId {
  const factory UserId(int value) = _UserId;

  factory UserId.fromJson(dynamic value) => UserId(value as int);
}

class UserIdConverter implements JsonConverter<UserId, int> {
  const UserIdConverter();

  @override
  UserId fromJson(int json) => UserId(json);

  @override
  int toJson(UserId object) => object.value;
}
