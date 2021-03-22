import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hinagata/app.dart';

void main() {
  debugPaintSizeEnabled =
      bool.fromEnvironment(Platform.environment['DEBUG_PAINT_SIZE'] ?? '');
  runApp(App());
}
