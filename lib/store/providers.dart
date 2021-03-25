import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/state/app/api_client/models/api_client.dart';
import 'package:native_app/store/state/app/api_client/notifier.dart';
import 'package:native_app/store/state/app/language/models/language.dart';
import 'package:native_app/store/state/app/language/notifier.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
import 'package:native_app/store/state/app/token/models/token.dart';
import 'package:native_app/store/state/app/token/notifier.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders() {
  return [
    StateNotifierProvider<TokenNotifier, EntityState<Token?>>(
        create: (context) => TokenNotifier()),
    StateNotifierProvider<LanguageNotifier, EntityState<Language?>>(
        create: (context) => LanguageNotifier()),
    StateNotifierProvider<ApiClientNotifier, ApiClient>(
        create: (context) => ApiClientNotifier()),
    StateNotifierProvider<LoginNotifier, EntityState<Login>>(
        create: (context) => LoginNotifier()),
  ];
}
