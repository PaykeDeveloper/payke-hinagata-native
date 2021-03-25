import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_token/models/backend_token.dart';
import 'package:native_app/store/state/app/language/models/language.dart';
import 'package:state_notifier/state_notifier.dart';

import 'models/backend_client.dart';

class BackendClientNotifier extends StateNotifier<BackendClient>
    with LocatorMixin {
  BackendClientNotifier() : super(BackendClient());

  @override
  void update(Locator watch) {
    super.update(watch);
    final token = watch<StoreState<BackendToken?>>().data;
    state.setToken(token);
    final language = watch<StoreState<Language?>>().data;
    state.setLanguage(language);
  }
}
