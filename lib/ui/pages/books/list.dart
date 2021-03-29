import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/models/books_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/ui/pages/books/detail.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  Future _initState() async {
    await context
        .read<BooksNotifier>()
        .fetchEntitiesIfNeeded(url: const BooksUrl(), reset: true);
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

  @override
  Widget build(BuildContext context) {
    final books = context.select(
        (EntitiesState<Book, BookUrl, Book, BooksUrl> state) => state.entities);

    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (context, index) => _ListItem(books[index]),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem(this._book);

  final Book _book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(_book.title, key: Key('text_${_book.id}')),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) {
                return BookDetailPage(_book.id);
              },
            ),
          );
        },
      ),
    );
  }
}
