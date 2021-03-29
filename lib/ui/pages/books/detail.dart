import 'package:flutter/material.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage(this.bookId);

  final BookId bookId;

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text('Client')));
          },
          child: const Text('Detail'),
        ),
      ),
    );
  }
}
