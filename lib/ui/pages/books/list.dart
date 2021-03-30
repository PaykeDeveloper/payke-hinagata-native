import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book.dart';
import 'package:native_app/store/state/domain/sample/books/models/books_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/add.dart';
import 'package:native_app/ui/pages/books/detail.dart';
import 'package:native_app/ui/pages/books/edit.dart';
import 'package:native_app/ui/widgets/atoms/tab_floating_action_button.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
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

  void _pushNextPage(WidgetBuilder builder) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return builder(context);
        },
      ),
    ).then((value) {
      _initState();
    });
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
    final books = context.select(booksSelector);

    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      floatingActionButton: TabFloatingActionButton(
        onPressed: () {
          _pushNextPage((context) {
            return BookAddPage();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Loader(
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
                onTapItem: () {
                  _pushNextPage((context) {
                    return BookDetailPage(book.id);
                  });
                },
                onPressedEdit: () {
                  _pushNextPage((context) {
                    return BookEditPage(book.id);
                  });
                },
              );
            },
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
          _book.title,
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
