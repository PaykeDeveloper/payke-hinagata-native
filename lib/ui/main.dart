import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_app/ui/pages/books/list.dart';
import 'package:native_app/ui/pages/common/home.dart';
import 'package:native_app/ui/pages/common/loading.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _getTabWidget(index);
            // return CupertinoPageScaffold(
            //   navigationBar: CupertinoNavigationBar(
            //     middle: Text('Page 1 of tab $index'),
            //   ),
            //   child: Center(
            //     child: CupertinoButton(
            //       child: const Text('Next page'),
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           CupertinoPageRoute<void>(
            //             builder: (BuildContext context) {
            //               return CupertinoPageScaffold(
            //                 navigationBar: CupertinoNavigationBar(
            //                   middle: Text('Page 2 of tab $index'),
            //                 ),
            //                 child: Center(
            //                   child: CupertinoButton(
            //                     child: const Text('Back'),
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     },
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }

  Widget _getTabWidget(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return BookListPage();
      default:
        return LoadingPage();
    }
  }
}
