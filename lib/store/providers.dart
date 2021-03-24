import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/store/base/models/api_client.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/language.dart';
import 'package:native_app/store/base/models/token.dart';
import 'package:native_app/store/base/notifiers/api_client.dart';
import 'package:native_app/store/base/notifiers/language.dart';
import 'package:native_app/store/base/notifiers/token.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
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
