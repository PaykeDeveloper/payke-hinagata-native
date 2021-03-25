// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_id.freezed.dart';

part 'book_id.g.dart';

@freezed
class BookId with _$BookId {
  const factory BookId(int value) = _BookId;

  factory BookId.fromJson(dynamic value) => BookId(value as int);
}
