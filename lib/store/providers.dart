import 'dart:ui';

import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/single_child_widget.dart';

import './base/models/entities_state.dart';
import './base/models/store_state.dart';
import './state/app/backend_client/models/backend_client.dart';
import './state/app/backend_client/notifier.dart';
import './state/app/backend_token/models/backend_token.dart';
import './state/app/backend_token/notifier.dart';
import './state/app/locale/notifier.dart';
import './state/app/login/notifier.dart';
import './state/domain/sample/books/models/book.dart';
import './state/domain/sample/books/models/book_url.dart';
import './state/domain/sample/books/models/books_url.dart';
import './state/domain/sample/books/notifier.dart';

List<SingleChildWidget> getProviders() {
  return [
    StateNotifierProvider<LocaleNotifier, Locale?>(
        create: (context) => LocaleNotifier()),
    StateNotifierProvider<BackendTokenNotifier, StoreState<BackendToken?>>(
        create: (context) => BackendTokenNotifier()),
    StateNotifierProvider<BackendClientNotifier, BackendClient>(
        create: (context) => BackendClientNotifier()),
    StateNotifierProvider<LoginNotifier, StoreState<Login>>(
        create: (context) => LoginNotifier()),

    // FIXME: SAMPLE CODE
    StateNotifierProvider<BooksNotifier,
            EntitiesState<Book, BookUrl, Book, BooksUrl>>(
        create: (context) => BooksNotifier(const EntitiesState())),
  ];
}
