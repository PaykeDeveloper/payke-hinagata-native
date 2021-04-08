import 'package:flutter/material.dart';
import 'package:native_app/store/state/app/route/models/route_state.dart';
import 'package:native_app/store/state/app/route/notifier.dart';
import 'package:native_app/store/state/domain/sample/books/models/book_id.dart';
import 'package:native_app/ui/pages/books/detail.dart';
import 'package:native_app/ui/pages/books/edit.dart';
import 'package:provider/provider.dart';

class HomePage extends Page {
  const HomePage({required ScaffoldState? mainState})
      : _mainState = mainState,
        super(key: const ValueKey("homePage"));
  final ScaffoldState? _mainState;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => HomeScreen(mainState: _mainState),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({required ScaffoldState? mainState})
      : _mainState = mainState;
  final ScaffoldState? _mainState;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textEditingController = TextEditingController();

  Future _onPressedBookList() async {
    final notifier = context.read<RouteStateNotifier>();
    await notifier.changeIndex(BottomTab.books);
    await notifier.replaceBookPages([]);
  }

  Future _onPressedBookDetail() async {
    final bookId = BookId(int.tryParse(_textEditingController.text) ?? 0);

    final notifier = context.read<RouteStateNotifier>();
    await notifier.changeIndex(BottomTab.books);
    await notifier.replaceBookPages([BookDetailPage(bookId: bookId)]);
  }

  Future _onPressedBookEdit() async {
    final bookId = BookId(int.tryParse(_textEditingController.text) ?? 0);

    final notifier = context.read<RouteStateNotifier>();
    await notifier.changeIndex(BottomTab.books);
    await notifier.replaceBookPages([
      BookDetailPage(bookId: bookId),
      BookEditPage(bookId: bookId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget._mainState?.openDrawer,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _onPressedBookList,
              child: const Text('Book list'),
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
              onPressed: _onPressedBookDetail,
              child: const Text('Book detail'),
            ),
            ElevatedButton(
              onPressed: _onPressedBookEdit,
              child: const Text('Book edit'),
            ),
          ],
        ),
      ),
    );
  }
}
