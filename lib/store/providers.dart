import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/app/language/models/language.dart';
import 'package:native_app/store/state/app/language/notifier.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
import 'package:native_app/store/state/app/token/models/token.dart';
import 'package:native_app/store/state/app/token/notifier.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders() {
  return [
    StateNotifierProvider<TokenNotifier, StoreState<Token?>>(
        create: (context) => TokenNotifier()),
    StateNotifierProvider<LanguageNotifier, StoreState<Language?>>(
        create: (context) => LanguageNotifier()),
    StateNotifierProvider<BackendClientNotifier, BackendClient>(
        create: (context) => BackendClientNotifier()),
    StateNotifierProvider<LoginNotifier, StoreState<Login>>(
        create: (context) => LoginNotifier()),
  ];
}
