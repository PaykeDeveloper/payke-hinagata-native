import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './app.dart';
import './base/constants.dart';

void main() {
  debugPaintSizeEnabled = debugPrintSize;
  runApp(const App());
}
