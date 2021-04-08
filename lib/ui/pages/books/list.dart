import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/store/state/domain/sample/books/models/books_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/add.dart';
import 'package:native_app/ui/pages/books/detail.dart';
import 'package:native_app/ui/pages/books/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class BookListPage extends Page {
  const BookListPage({required ScaffoldState? mainState})
      : _mainState = mainState,
        super(key: const ValueKey("bookListPage"));
  final ScaffoldState? _mainState;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => BookListScreen(mainState: _mainState),
    );
  }
}

class BookListScreen extends StatefulWidget {
  const BookListScreen({required ScaffoldState? mainState})
      : _mainState = mainState;
  final ScaffoldState? _mainState;

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  bool _loading = false;

  Future _initState() async {
    setState(() {
      _loading = true;
    });
    await context
        .read<BooksNotifier>()
        .fetchEntitiesIfNeeded(url: const BooksUrl(), reset: true);
    setState(() {
      _loading = false;
    });
  }

  Future _onRefresh() async {
    await context.read<BooksNotifier>().fetchEntities(url: const BooksUrl());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initState();
    });
  }

  void _onPressedNew() {
    context.read<RouteStateNotifier>().pushBookPage(const BookAddPage());
  }

  void _onTapShow(BookId bookId) {
    context
        .read<RouteStateNotifier>()
        .pushBookPage(BookDetailPage(bookId: bookId));
  }

  void _onPressedEdit(BookId bookId) {
    context
        .read<RouteStateNotifier>()
        .pushBookPage(BookEditPage(bookId: bookId));
  }

  @override
  Widget build(BuildContext context) {
    final books = context.select(booksSelector);
    final error = context.select(booksErrorSelector);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._mainState?.openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedNew,
        child: const Icon(Icons.add),
      ),
      body: ErrorWrapper(
        error: error,
        onPressedReload: _initState,
        child: Loader(
          loading: _loading,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _ListItem(
                  book: book,
                  onTapItem: () => _onTapShow(book.id),
                  onPressedEdit: () => _onPressedEdit(book.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required Book book,
    required GestureTapCallback onTapItem,
    required VoidCallback onPressedEdit,
  })   : _book = book,
        _onTapItem = onTapItem,
        _onPressedEdit = onPressedEdit;

  final Book _book;
  final GestureTapCallback _onTapItem;
  final VoidCallback _onPressedEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: _onTapItem,
        title: Text(
          '${_book.id.value}: ${_book.title}',
          key: Key('text_${_book.id}'),
        ),
        trailing: IconButton(
          key: Key('icon_${_book.id}'),
          icon: const Icon(Icons.edit),
          onPressed: _onPressedEdit,
        ),
      ),
    );
  }
}
