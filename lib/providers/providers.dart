import 'package:hinagata/providers/favorites.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider(create: (context) => Favorites()),
];
