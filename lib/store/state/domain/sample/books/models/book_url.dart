// FIXME: SAMPLE CODE
import 'package:freezed_annotation/freezed_annotation.dart';

import 'book_id.dart';

part 'book_url.freezed.dart';

@freezed
class BookUrl with _$BookUrl {
  const factory BookUrl({
    required BookId id,
  }) = _BookUrl;
}
