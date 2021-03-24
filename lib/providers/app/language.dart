import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/language.dart';
import 'package:native_app/models/app/provider_state.dart';
import 'package:state_notifier/state_notifier.dart';

class LanguageProvider extends StateNotifier<ProviderState<Language?>>
    with LocatorMixin {
  LanguageProvider() : super(const ProviderState(null));

  Language? get language => state.data;

  @override
  Future initState() async {
    state = state.copyWith(status: StateStatus.started);
    await _fetch();
  }

  Future _fetch() async {
    final value = await Preference.language.get();
    final language = value != null ? LanguageExt.fromIso639_1(value) : null;
    state = state.copyWith(data: language, status: StateStatus.done);
  }

  Future<bool> set(Language language) async {
    final result = await Preference.language.set(language.iso639_1);
    _fetch();
    return result;
  }
}
