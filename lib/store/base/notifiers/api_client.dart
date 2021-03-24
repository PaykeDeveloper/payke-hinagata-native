import 'package:native_app/store/base/models/api_client.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/language.dart';
import 'package:native_app/store/base/models/token.dart';
import 'package:state_notifier/state_notifier.dart';

class ApiClientNotifier extends StateNotifier<ApiClient> with LocatorMixin {
  ApiClientNotifier() : super(ApiClient());

  @override
  void update(T Function<T>() watch) {
    super.update(watch);
    final token = watch<EntityState<Token?>>().data;
    state.setToken(token);
    final language = watch<EntityState<Language?>>().data;
    state.setLanguage(language);
  }
}
