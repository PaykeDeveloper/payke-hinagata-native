import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const RouteState._();

  const factory RouteState({
    required int tabIndex,
    BookId? bookDetailId,
    BookId? bookEditId,
    @Default(false) bool bookNew,
  }) = _RouteState;

  bool isFirstTab() {
    return bookDetailId == null && bookEditId == null && !bookNew;
  }
}
