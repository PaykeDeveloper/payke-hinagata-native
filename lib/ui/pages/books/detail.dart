import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/edit.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class _BookDetailArgs {
  final BookId bookId;

  _BookDetailArgs(this.bookId);
}

class BookDetailPage extends StatefulWidget {
  static const routeName = '/book';

  static CupertinoPageRoute getRoute({required BookId bookId}) =>
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return BookDetailPage();
        },
        settings: RouteSettings(
          name: BookDetailPage.routeName,
          arguments: _BookDetailArgs(bookId),
        ),
      );

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  _BookDetailArgs get _args =>
      ModalRoute.of(context)!.settings.arguments! as _BookDetailArgs;

  Future _initState() async {
    await context
        .read<BooksNotifier>()
        .fetchEntityIfNeeded(url: BookUrl(id: _args.bookId), reset: true);
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
            onPressed: book == null
                ? null
                : () {
                    Navigator.of(context)
                        .push(BookEditPage.getRoute(bookId: book.id));
                  },
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
