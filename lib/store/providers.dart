import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/store/base/models/api_client.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/language.dart';
import 'package:native_app/store/base/models/token.dart';
import 'package:native_app/store/base/providers/api_client.dart';
import 'package:native_app/store/base/providers/language.dart';
import 'package:native_app/store/base/providers/token.dart';
import 'package:native_app/store/state/app/login/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders() {
  return [
    StateNotifierProvider<TokenProvider, EntityState<Token?>>(
        create: (context) => TokenProvider()),
    StateNotifierProvider<LanguageProvider, EntityState<Language?>>(
        create: (context) => LanguageProvider()),
    StateNotifierProvider<ApiClientProvider, ApiClient>(
        create: (context) => ApiClientProvider()),
    StateNotifierProvider<LoginProvider, EntityState<Login>>(
        create: (context) => LoginProvider()),
  ];
}
