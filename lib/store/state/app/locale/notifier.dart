import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  Future setLocale(Locale locale) async {
    state = locale;
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale?>((ref) => LocaleNotifier());
