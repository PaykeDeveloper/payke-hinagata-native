import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/ui/utils/main_interface.dart';
import 'package:provider/provider.dart';

class HomePage extends Page {
  const HomePage({
    LocalKey? key,
    required MainInterface main,
  })   : _main = main,
        super(key: key);
  final MainInterface _main;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => HomeScreen(main: _main),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({required MainInterface main}) : _main = main;
  final MainInterface _main;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textEditingController = TextEditingController();

  void _onPressedBookList() {
    context.read<RouteStateNotifier>().showBookList();
  }

  void _onPressedBook(BookId bookId) {
    context.read<RouteStateNotifier>().showBookEdit(bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._main.openDrawer,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _onPressedBookList,
              child: const Text('Open books'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(labelText: 'Book Id'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text('No book'),
                // ));

                final bookId =
                    BookId(int.tryParse(_textEditingController.text) ?? 0);
                _onPressedBook(bookId);
              },
              child: const Text('Open book'),
            ),
          ],
        ),
      ),
    );
  }
}
