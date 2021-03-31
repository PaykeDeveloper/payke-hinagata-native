import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/models/state_error.dart';
import 'package:native_app/store/base/models/store_state.dart';

import './models/book.dart';
import './models/book_url.dart';
import './models/books_url.dart';

List<Book> booksSelector(EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entities;

StateStatus booksStatusSelector(
        EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entitiesStatus;

StateError? booksErrorSelector(
        EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entitiesError;

Book? bookSelector(EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entity;

StateStatus bookStatusSelector(
        EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entityStatus;

StateError? bookErrorSelector(
        EntitiesState<Book, BookUrl, Book, BooksUrl> state) =>
    state.entityError;
