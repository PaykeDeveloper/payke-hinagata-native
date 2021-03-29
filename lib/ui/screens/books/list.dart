import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/models/books_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  void _fetchBooks() {
    context.read<BooksNotifier>().fetchEntitiesIfNeeded(url: const BooksUrl());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final books =
        context.watch<EntitiesState<Book, BookUrl, Book, BooksUrl>>().entities;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: books.length,
        cacheExtent: 20.0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => _ListItem(books[index]),
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
        title: Text(
          _book.title,
          key: Key('text_${_book.id}'),
        ),
      ),
    );
  }
}
