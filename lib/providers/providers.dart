import 'package:native_app/providers/app/api_client.dart';
import 'package:native_app/providers/app/language.dart';
import 'package:native_app/providers/app/login.dart';
import 'package:native_app/providers/app/token.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<TokenProvider>(create: (context) => TokenProvider()),
  ChangeNotifierProvider<LanguageProvider>(
      create: (context) => LanguageProvider()),
  ChangeNotifierProxyProvider2<TokenProvider, LanguageProvider,
      ApiClientProvider>(
    create: (context) => ApiClientProvider(null, null),
    update: (context, tokenProvider, languageProvider, previous) =>
        ApiClientProvider(tokenProvider, languageProvider),
  ),
  ChangeNotifierProxyProvider<ApiClientProvider, LoginProvider>(
    create: (context) => LoginProvider(null),
    update: (context, value, previous) => LoginProvider(value),
  )
];
