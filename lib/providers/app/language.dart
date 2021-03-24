import 'package:flutter/foundation.dart';
import 'package:native_app/base/preference.dart';
import 'package:native_app/models/app/language.dart';

class LanguageProvider with ChangeNotifier {
  LanguageProvider() {
    _load();
  }

  bool _loaded = false;

  bool get loaded => _loaded;

  Language? _language;

  Language? get language => _language;

  Future _load() async {
    final value = await Preference.language.get();
    _language = value != null ? LanguageExt.fromIso639_1(value) : null;
    _loaded = true;
    notifyListeners();
  }

  Future<bool> set(Language language) async {
    final result = await Preference.language.set(language.iso639_1);
    _load();
    return result;
  }

  Future<bool?> remove() async {
    return Preference.language.remove();
  }
}
