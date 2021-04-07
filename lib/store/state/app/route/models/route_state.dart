import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';

part 'route_state.freezed.dart';

const tabHome = 0;
const tabBooks = 1;

@freezed
class RouteState with _$RouteState {
  const RouteState._();

  const factory RouteState({
    required int tabIndex,
    BookId? bookDetailId,
    BookId? bookEditId,
    @Default(false) bool bookNew,
  }) = _RouteState;

  bool get isFirstTab {
    switch (tabIndex) {
      case tabHome:
        return true;
      case tabBooks:
        return bookDetailId == null && bookEditId == null && !bookNew;
    }
    return true;
  }
}
