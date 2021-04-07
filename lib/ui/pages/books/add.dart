import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_input.dart';
import 'package:native_app/store/state/domain/sample/books/models/books_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/widgets/form.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class BookAddPage extends Page {
  const BookAddPage({LocalKey? key}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => BookAddScreen(),
    );
  }
}

class BookAddScreen extends StatefulWidget {
  @override
  _BookAddScreenState createState() => _BookAddScreenState();
}

class _BookAddScreenState extends State<BookAddScreen> {
  Future<StoreResult?> _onSubmit(BookInput input) async {
    final result = await context
        .read<BooksNotifier>()
        .addEntity(urlParams: const BooksUrl(), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select(booksErrorSelector);
    final status = context.select(booksStatusSelector);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add book'),
      ),
      body: ErrorWrapper(
        error: error,
        child: Loader(
          status: status,
          child: BookForm(
            book: null,
            status: status,
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
