import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/ui/utils/main_interface.dart';

class HomePage extends StatefulWidget {
  const HomePage({required MainInterface main}) : _main = main;

  static const routeName = '/';

  final MainInterface _main;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textEditingController = TextEditingController();

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
              onPressed: () {
                widget._main.openBooks();
              },
              child: const Text('Open books'),
            ),
            // const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: TextField(
            //     controller: _textEditingController,
            //     decoration: const InputDecoration(labelText: 'Book Id'),
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //     //   content: Text('No book'),
            //     // ));
            //
            //     final bookId =
            //         BookId(int.tryParse(_textEditingController.text) ?? 0);
            //     widget._main.openBookDetail(bookId: bookId);
            //   },
            //   child: const Text('Open book'),
            // ),
          ],
        ),
      ),
    );
  }
}
