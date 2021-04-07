import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:state_notifier/state_notifier.dart';

import './models/route_state.dart';

class RouteStateNotifier extends StateNotifier<RouteState> with LocatorMixin {
  RouteStateNotifier() : super(const RouteState(tabIndex: tabHome));

  Future changeIndex(int index) async {
    state = state.copyWith(
      tabIndex: index,
    );
  }

  Future showBookList() async {
    state = state.copyWith(
      tabIndex: tabBooks,
      bookDetailId: null,
      bookEditId: null,
      bookNew: false,
    );
  }

  Future showBookDetail(BookId bookId) async {
    state = state.copyWith(
      tabIndex: tabBooks,
      bookDetailId: bookId,
      bookEditId: null,
      bookNew: false,
    );
  }

  Future removeBookDetail() async {
    state = state.copyWith(
      bookDetailId: null,
    );
  }

  Future showBookEdit(BookId bookId) async {
    state = state.copyWith(
      tabIndex: tabBooks,
      bookEditId: bookId,
      bookNew: false,
    );
  }

  Future removeBookEdit() async {
    state = state.copyWith(
      bookEditId: null,
    );
  }

  Future removeBook() async {
    state = state.copyWith(
      bookDetailId: null,
      bookEditId: null,
    );
  }

  Future showBookNew() async {
    state = state.copyWith(
      tabIndex: tabBooks,
      bookDetailId: null,
      bookEditId: null,
      bookNew: true,
    );
  }

  Future removeBookNew() async {
    state = state.copyWith(
      bookNew: false,
    );
  }
}
