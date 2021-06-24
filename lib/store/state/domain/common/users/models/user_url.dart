import 'package:freezed_annotation/freezed_annotation.dart';

import './user_id.dart';

part 'user_url.freezed.dart';

@freezed
class UserUrl with _$UserUrl {
  const factory UserUrl({
    required UserId id,
  }) = _UserUrl;
}
