import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends Page {
  BookDetailPage({required BookId bookId})
      : _bookId = bookId,
        super(key: ValueKey("bookDetailPage-${bookId.value}"));
  final BookId _bookId;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => BookDetailScreen(bookId: _bookId),
    );
  }
}

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({required BookId bookId}) : _bookId = bookId;
  final BookId _bookId;

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Future _initState() async {
    await context
        .read<BooksNotifier>()
        .fetchEntityIfNeeded(url: BookUrl(id: widget._bookId), reset: true);
  }

  void _onPressedEdit() {
    context
        .read<RouteStateNotifier>()
        .pushBookPage(BookEditPage(bookId: widget._bookId));
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
        title: const Text('Book detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit book',
            onPressed: book == null ? null : _onPressedEdit,
          ),
        ],
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          status: status,
          child: Center(
            child: Text('Title: ${book?.title}'),
          ),
        ),
      ),
    );
  }
}
