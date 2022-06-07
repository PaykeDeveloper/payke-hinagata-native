import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    buttonTheme: const ButtonThemeData(height: 48),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
