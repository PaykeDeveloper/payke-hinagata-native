import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_id.freezed.dart';
part 'member_id.g.dart';

@freezed
class MemberId with _$MemberId {
  const factory MemberId(int value) = _MemberId;

  factory MemberId.fromJson(dynamic value) => MemberId(value as int);
}
