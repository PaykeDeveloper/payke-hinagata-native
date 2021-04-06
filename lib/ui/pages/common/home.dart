import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/selectors.dart';
import 'package:native_app/ui/extensions/list.dart';
import 'package:native_app/ui/pages/books/detail.dart';
import 'package:native_app/ui/utils/main_interface.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({required MainInterface main}) : _main = main;

  final MainInterface _main;

  @override
  Widget build(BuildContext context) {
    final book = context.select(booksSelector).firstOrNull();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _main.getScaffoldState()?.openDrawer,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                _main.getNavigatorState(1)?.popUntil((route) => route.isFirst);
              },
              child: const Text('Open books'),
            ),
            ElevatedButton(
              onPressed: () {
                if (book == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No book'),
                  ));
                } else {
                  _main.getNavigatorState(1)?.pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (BuildContext context) {
                        return BookDetailPage(book.id);
                      },
                    ),
                    (route) => route.isFirst,
                  );
                }
              },
              child: const Text('Open book'),
            ),
          ],
        ),
      ),
    );
  }
}
