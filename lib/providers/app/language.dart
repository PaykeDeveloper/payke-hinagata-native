import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/language.dart';
import 'package:state_notifier/state_notifier.dart';

class LanguageProvider extends StateNotifier<Language?> {
  LanguageProvider() : super(null) {
    _fetch();
  }

  Language? get language => state;

  Future<bool> set(Language language) async {
    final result = await Preference.language.set(language.iso639_1);
    _fetch();
    return result;
  }

  Future<bool?> remove() async {
    return Preference.language.remove();
  }

  Future _fetch() async {
    final value = await Preference.language.get();
    final language = value != null ? LanguageExt.fromIso639_1(value) : null;
    state = language;
  }
}
