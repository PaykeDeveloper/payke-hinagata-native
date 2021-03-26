enum Language {
  japanese,
  traditionalChinese,
  simplifiedChinese,
}

extension LanguageExt on Language {
  /// language
  /// language-script
  static final _bcp47 = {
    Language.japanese: 'ja',
    Language.traditionalChinese: 'zh-Hant',
    Language.simplifiedChinese: 'zh-Hans',
  };

  String get bcp47 => _bcp47[this]!;

  static Language fromBcp47(String language) =>
      _bcp47.keys.firstWhere((element) => _bcp47[element] == language);
}
