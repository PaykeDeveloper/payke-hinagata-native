// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import './division_id.dart';

part 'division_url.freezed.dart';

@freezed
class DivisionUrl with _$DivisionUrl {
  const factory DivisionUrl({
    required DivisionId id,
  }) = _DivisionUrl;
}
