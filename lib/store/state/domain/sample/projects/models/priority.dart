// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

const _high = 'high';
const _middle = 'middle';
const _low = 'low';

enum Priority {
  @JsonValue(_high)
  high,
  @JsonValue(_middle)
  middle,
  @JsonValue(_low)
  low,
}

extension PriorityExt on Priority {
  String getValue() {
    switch (this) {
      case Priority.high:
        return _high;
      case Priority.middle:
        return _middle;
      case Priority.low:
        return _low;
    }
  }

  static Priority fromValue(String value) {
    switch (value) {
      case _high:
        return Priority.high;
      case _middle:
        return Priority.middle;
      case _low:
        return Priority.low;
      default:
        throw ArgumentError.value(value);
    }
  }
}
