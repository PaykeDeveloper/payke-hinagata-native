import 'package:native_app/providers/app/login.dart';
import 'package:native_app/providers/app/token.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<TokenProvider>(create: (context) => TokenProvider()),
  ChangeNotifierProxyProvider<TokenProvider, LoginProvider>(
    create: (context) => LoginProvider(null),
    update: (context, value, previous) => LoginProvider(value),
  )
];
