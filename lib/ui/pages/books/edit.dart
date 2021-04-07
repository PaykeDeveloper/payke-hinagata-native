import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_input.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_url.dart';
import 'package:native_app/store/state/domain/sample/books/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/pages/books/list.dart';
import 'package:native_app/ui/pages/books/widgets/form.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/molecules/error_wrapper.dart';
import 'package:native_app/ui/widgets/molecules/laoder.dart';
import 'package:provider/provider.dart';

class _BookEditArgs {
  final BookId bookId;

  _BookEditArgs(this.bookId);
}

class BookEditPage extends StatefulWidget {
  static const routeName = '/book/edit';

  static CupertinoPageRoute getRoute({required BookId bookId}) {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return BookEditPage();
      },
      settings: RouteSettings(
        name: routeName,
        arguments: _BookEditArgs(bookId),
      ),
    );
  }

  @override
  _BookEditPageState createState() => _BookEditPageState();
}

class _BookEditPageState extends ValidateFormState<BookEditPage> {
  _BookEditArgs get _args =>
      ModalRoute.of(context)!.settings.arguments! as _BookEditArgs;

  Future _initState() async {
    await context
        .read<BooksNotifier>()
        .fetchEntityIfNeeded(url: BookUrl(id: _args.bookId), reset: true);
  }

  Future<StoreResult?> _onSubmit(BookInput input) async {
    final result = await context
        .read<BooksNotifier>()
        .mergeEntity(urlParams: BookUrl(id: _args.bookId), data: input);
    if (result is Success) {
      Navigator.of(context).pop();
    }
    return result;
  }

  Future _onPressedDelete() async {
    final result = await context
        .read<BooksNotifier>()
        .deleteEntity(urlParams: BookUrl(id: _args.bookId));
    if (result is Success) {
      Navigator.of(context)
          .popUntil((route) => route.settings.name == BookListPage.routeName);
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
