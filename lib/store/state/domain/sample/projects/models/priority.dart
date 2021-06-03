import 'package:freezed_annotation/freezed_annotation.dart';

enum Priority {
  @JsonValue('high')
  high,
  @JsonValue('middle')
  middle,
  @JsonValue('low')
  low,
}
