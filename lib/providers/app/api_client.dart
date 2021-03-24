import 'package:native_app/base/api/client.dart';
import 'package:native_app/providers/app/language.dart';
import 'package:native_app/providers/app/token.dart';
import 'package:state_notifier/state_notifier.dart';

class ApiClientProvider extends StateNotifier<ApiClient> with LocatorMixin {
  ApiClientProvider() : super(ApiClient());

  @override
  void update(T Function<T>() watch) {
    super.update(watch);
    final token = watch<TokenProvider>().token;
    state.token = token;
    final language = watch<LanguageProvider>().language;
    state.language = language;
  }
}
