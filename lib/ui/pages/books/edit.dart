import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_input.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/widgets/form.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class BookEditPage extends Page {
  const BookEditPage({required BookId bookId}) : _bookId = bookId;
  final BookId _bookId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => BookEditScreen(bookId: _bookId),
    );
  }
}

class BookEditScreen extends StatefulWidget {
  const BookEditScreen({required BookId bookId}) : _bookId = bookId;
  final BookId _bookId;

  @override
  _BookEditScreenState createState() => _BookEditScreenState();
}

class _BookEditScreenState extends ValidateFormState<BookEditScreen> {
  Future _initState() async {
    await context
        .read<BooksNotifier>()
        .fetchEntityIfNeeded(url: BookUrl(id: widget._bookId), reset: true);
  }

  Future<StoreResult?> _onSubmit(BookInput input) async {
    final result = await context
        .read<BooksNotifier>()
        .mergeEntity(urlParams: BookUrl(id: widget._bookId), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  Future _onPressedDelete() async {
    final result = await context
        .read<BooksNotifier>()
        .deleteEntity(urlParams: BookUrl(id: widget._bookId));
    if (result is Success) {
      await context.read<RouteStateNotifier>().removeBookEdit();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = context.select(bookSelector);
    final error = context.select(bookErrorSelector);
    final status = context.select(bookStatusSelector);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete book',
            onPressed: book == null ? null : _onPressedDelete,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: BookForm(
            book: book,
            status: status,
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
