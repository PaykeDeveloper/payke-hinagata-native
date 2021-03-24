import 'package:native_app/base/preference.dart';
import 'package:native_app/store/base/models/entity_state.dart';
import 'package:native_app/store/base/models/language.dart';
import 'package:state_notifier/state_notifier.dart';

class LanguageProvider extends StateNotifier<EntityState<Language?>>
    with LocatorMixin {
  LanguageProvider() : super(const EntityState(null));

  Language? get language => state.data;

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

  Future<bool> set(Language language) async {
    final result = await Preference.language.set(language.iso639_1);
    state = state.copyWith(data: language, status: StateStatus.done);
    return result;
  }
}
