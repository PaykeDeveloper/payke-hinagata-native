import 'package:hinagata/ui/pages/favorites.dart';
import 'package:hinagata/ui/pages/home.dart';

final routes = {
  HomePage.routeName: (context) => HomePage(),
  FavoritesPage.routeName: (context) => FavoritesPage(),
};

final initialRoute = HomePage.routeName;
