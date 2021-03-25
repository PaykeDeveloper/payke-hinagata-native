import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/language/models/language.dart';
import 'package:native_app/store/state/app/token/models/token.dart';
import 'package:state_notifier/state_notifier.dart';

import 'models/api_client.dart';

class ApiClientNotifier extends StateNotifier<ApiClient> with LocatorMixin {
  ApiClientNotifier() : super(ApiClient());

  @override
  void update(Locator watch) {
    super.update(watch);
    final token = watch<StoreState<Token?>>().data;
    state.setToken(token);
    final language = watch<StoreState<Language?>>().data;
    state.setLanguage(language);
  }
}
