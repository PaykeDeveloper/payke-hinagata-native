import 'package:native_app/providers/app/auth.dart';
import 'package:native_app/providers/favorites.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<Favorites>(create: (context) => Favorites()),
  ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
];
