import 'package:native_app/base/preferences.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:state_notifier/state_notifier.dart';

import 'models/language.dart';

class LanguageNotifier extends StateNotifier<StoreState<Language?>>
    with LocatorMixin {
  LanguageNotifier() : super(const StoreState(null));

  @override
  void initState() {
    super.initState();
    state = state.copyWith(status: StateStatus.started);
    _fetch();
  }

  Future _fetch() async {
    final value = await Preferences.language.get();
    final language = value != null ? LanguageExt.fromBcp47(value) : null;
    state = state.copyWith(data: language, status: StateStatus.done);
  }

  Future<bool> setLanguage(Language language) async {
    final result = await Preferences.language.set(language.bcp47);
    state = state.copyWith(data: language, status: StateStatus.done);
    return result;
  }
}
