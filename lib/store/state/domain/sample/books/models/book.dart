// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import './book_id.dart';

part 'book.freezed.dart';

part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required BookId id,
    required String title,
    String? author,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
