import 'dart:ui';

import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:provider/single_child_widget.dart';

import './base/models/entities_state.dart';
import './base/models/store_state.dart';
import './state/app/backend_client/models/backend_client.dart';
import './state/app/backend_client/notifier.dart';
import './state/app/backend_token/models/backend_token.dart';
import './state/app/backend_token/notifier.dart';
import './state/app/locale/notifier.dart';
import './state/app/login/notifier.dart';
import './state/app/logout/notifier.dart';
import './state/domain/division/divisions/models/division.dart';
import './state/domain/division/divisions/models/division_url.dart';
import './state/domain/division/divisions/models/divisions_url.dart';
import './state/domain/division/divisions/notifier.dart';
import './state/domain/sample/books/models/book.dart';
import './state/domain/sample/books/models/book_url.dart';
import './state/domain/sample/books/models/books_url.dart';
import './state/domain/sample/books/notifier.dart';
import './state/ui/division_id/notifier.dart';

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
    StateNotifierProvider<LogoutNotifier, StoreState<Logout>>(
        create: (context) => LogoutNotifier()),
    StateNotifierProvider<RouteStateNotifier, RouteState>(
        create: (context) => RouteStateNotifier()),

    // FIXME: SAMPLE CODE
    StateNotifierProvider<DivisionIdNotifier, StoreState<DivisionId?>>(
        create: (context) => DivisionIdNotifier()),
    StateNotifierProvider<DivisionsNotifier,
            EntitiesState<Division, DivisionUrl, Division, DivisionsUrl>>(
        create: (context) => DivisionsNotifier(const EntitiesState())),
    StateNotifierProvider<BooksNotifier,
            EntitiesState<Book, BookUrl, Book, BooksUrl>>(
        create: (context) => BooksNotifier(const EntitiesState())),
  ];
}
