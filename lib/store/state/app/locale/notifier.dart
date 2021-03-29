import 'dart:ui';

import 'package:state_notifier/state_notifier.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  Future setLocale(Locale locale) async {
    state = locale;
  }
}
