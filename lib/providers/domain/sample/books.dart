import 'package:flutter/foundation.dart';
import 'package:native_app/models/domain/sample/book.dart';

class BooksProvider with ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books => _books;

  void add(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void remove(Book book) {
    _books.remove(book);
    notifyListeners();
  }
}
