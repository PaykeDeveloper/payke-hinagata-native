// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_id.freezed.dart';
part 'member_id.g.dart';

@freezed
class MemberId with _$MemberId {
  const factory MemberId(int value) = _MemberId;

  factory MemberId.fromJson(dynamic value) => MemberId(value as int);
}

class MemberIdConverter implements JsonConverter<MemberId, int> {
  const MemberIdConverter();

  @override
  MemberId fromJson(int json) => MemberId(json);

  @override
  int toJson(MemberId object) => object.value;
}
