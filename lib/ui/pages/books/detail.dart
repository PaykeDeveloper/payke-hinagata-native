import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage(this.bookId);

  final BookId bookId;

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Future _initState() async {
    await context
        .read<BooksNotifier>()
        .fetchEntityIfNeeded(url: BookUrl(id: widget.bookId), reset: true);
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
    final status = context.select(bookStatusSelector);
    return Scaffold(
      appBar: AppBar(title: const Text('Book detail')),
      body: Loader(
        status: status,
        child: Center(
          child: Text('Title: ${book?.title}'),
        ),
      ),
    );
  }
}
