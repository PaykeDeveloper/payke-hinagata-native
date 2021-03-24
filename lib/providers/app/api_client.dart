import 'package:flutter/foundation.dart';
import 'package:native_app/base/api/client.dart';
import 'package:native_app/providers/app/language.dart';
import 'package:native_app/providers/app/token.dart';

final _client = ApiClient();

class ApiClientProvider with ChangeNotifier {
  ApiClientProvider(
    TokenProvider? tokenProvider,
    LanguageProvider? languageProvider,
  ) {
    _client.token = tokenProvider?.token;
    _client.language = languageProvider?.language;
  }

  ApiClient get client => _client;
}
