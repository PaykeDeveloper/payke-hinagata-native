enum Language {
  japanese,
}

extension LanguageExt on Language {
  static final _iso639_1 = {
    Language.japanese: 'ja',
  };

  String get iso639_1 => _iso639_1[this]!;

  static Language fromIso639_1(String language) =>
      _iso639_1.keys.firstWhere((element) => _iso639_1[element] == language);
}
