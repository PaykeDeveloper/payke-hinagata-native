import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class LocaleState extends _$LocaleState {
  @override
  Locale? build() => null;

  Future setLocale(Locale locale) async {
    state = locale;
  }
}
