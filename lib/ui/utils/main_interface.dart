import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';

abstract class MainInterface {
  void openDrawer() {}

  void openBooks() {}

  void openBook(BookId bookId) {}
}
