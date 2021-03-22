import 'package:native_app/ui/pages/favorites.dart';
import 'package:native_app/ui/pages/home.dart';

final routes = {
  HomePage.routeName: (context) => HomePage(),
  FavoritesPage.routeName: (context) => FavoritesPage(),
};

final initialRoute = HomePage.routeName;
