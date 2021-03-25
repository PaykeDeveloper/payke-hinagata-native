import 'package:native_app/base/preference.dart';
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
    final value = await Preference.language.get();
    final language = value != null ? LanguageExt.fromIso639_1(value) : null;
    state = state.copyWith(data: language, status: StateStatus.done);
  }

  Future<bool> setLanguage(Language language) async {
    final result = await Preference.language.set(language.iso639_1);
    state = state.copyWith(data: language, status: StateStatus.done);
    return result;
  }
}
