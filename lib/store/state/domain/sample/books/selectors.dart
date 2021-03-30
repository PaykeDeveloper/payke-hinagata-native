import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/models/books_url.dart';

List<Book> booksSelector(EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entities;

StateStatus booksStatusSelector(
        EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entitiesStatus;

Book? bookSelector(EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entity;

StateStatus bookStatusSelector(
        EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entityStatus;
