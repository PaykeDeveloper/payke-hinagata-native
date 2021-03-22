import 'package:native_app/providers/app/token.dart';
import 'package:native_app/providers/favorites.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<Favorites>(create: (context) => Favorites()),
  ChangeNotifierProvider<TokenProvider>(create: (context) => TokenProvider()),
];
