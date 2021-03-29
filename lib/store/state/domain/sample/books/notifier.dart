// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';

import 'models/book.dart';
import 'models/book_input.dart';
import 'models/book_url.dart';
import 'models/books_url.dart';

class BooksNotifier extends EntitiesNotifier<Book, BookUrl, Book, BooksUrl,
    BookInput, BookInput> {
  BooksNotifier(EntitiesState<Book, BookUrl, Book, BooksUrl> state)
      : super(state);

  @override
  String getEntitiesUrl(BooksUrl url) => 'api/v1/books/';

  @override
  String getEntityUrl(BookUrl url) => 'api/v1/books/${url.id.value}/';

  @override
  Book decodeEntities(Map<String, dynamic> json) => Book.fromJson(json);

  @override
  Book decodeEntity(Map<String, dynamic> json) => Book.fromJson(json);
}
