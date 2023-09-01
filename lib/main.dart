import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './app.dart';
import './base/constants.dart';

void main() {
  debugPaintSizeEnabled = debugPrintSize;
  runApp(const ProviderScope(child: App()));
}
