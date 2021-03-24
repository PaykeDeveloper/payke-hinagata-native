import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/base/api/client.dart';
import 'package:native_app/models/app/language.dart';
import 'package:native_app/models/app/provider_state.dart';
import 'package:native_app/models/app/token.dart';
import 'package:native_app/providers/app/api_client.dart';
import 'package:native_app/providers/app/language.dart';
import 'package:native_app/providers/app/login.dart';
import 'package:native_app/providers/app/token.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders() {
  return [
    StateNotifierProvider<TokenProvider, ProviderState<Token?>>(
        create: (context) => TokenProvider()),
    StateNotifierProvider<LanguageProvider, ProviderState<Language?>>(
        create: (context) => LanguageProvider()),
    StateNotifierProvider<ApiClientProvider, ApiClient>(
        create: (context) => ApiClientProvider()),
    StateNotifierProvider<LoginProvider, ProviderState<Login>>(
        create: (context) => LoginProvider()),
  ];
}
